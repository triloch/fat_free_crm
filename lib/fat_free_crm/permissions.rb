# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCRM
  module Permissions
    extend ActiveSupport::Concern

    included do

    end

    module ClassMethods
      def uses_user_permissions
        has_many :permissions, as: :asset
        attr_accessor :dirty

        scope :my, lambda {
          accessible_by(User.current_ability)
        }
        include FatFreeCRM::Permissions::InstanceMethods
      end
    end


    module InstanceMethods
      def make_dirty
        self.dirty = true
      end

      def changed?
        dirty || super
      end

      def user_ids=(value)
        if access != 'Shared'
          remove_permissions
        else
          value = value.flatten.reject(&:blank?).uniq.map(&:to_i)
          permissions_to_remove = Permission.where(
                user_id: self.user_ids - value,
                asset_id: self.id,
                asset_type: self.class
              )
          permissions_to_remove.each {|p| (permissions.delete(p); p.destroy)}
              (value - self.user_ids).each {|id| permissions.build(:user_id => id)}
          make_dirty
        end
      end

      def user_ids
        permissions.map(&:user_id).compact
      end


      def group_ids=(value)
        if access != 'Shared'
          remove_permissions
        else
          value = value.flatten.reject(&:blank?).uniq.map(&:to_i)
          permissions_to_remove = Permission.where(
                group_id: self.group_ids - value,
                asset_id: self.id,
                asset_type: self.class
              )
          permissions_to_remove.each {|p| (permissions.delete(p); p.destroy)}
              (value - self.group_ids).each {|id| permissions.build(:group_id => id)}
          make_dirty
        end
      end

      def group_ids
        permissions.map(&:group_id).compact
      end

      # Remove all shared permissions if no longer shared
      #--------------------------------------------------------------------------
      def access=(value)
        remove_permissions unless value == 'Shared'
        super(value)
      end

      # Removes all permissions on an object
      #--------------------------------------------------------------------------
      def remove_permissions
        # we don't use dependent => :destroy so must manually remove
        if id && self.class
          permissions_to_remove = Permission.where(asset_id: id, asset_type: self.class.to_s).to_a
        else
          permissions_to_remove = []
        end

        permissions_to_remove.each { |p| (permissions.delete(p); p.destroy) }
      end

      # Save the model along with its permissions if any.
      #--------------------------------------------------------------------------
      def save_with_permissions(_users = nil)
        ActiveSupport::Deprecation.warn "save_with_permissions is deprecated and may be removed from future releases, use user_ids and group_ids inside attributes instead."
        save
      end

      # Update the model along with its permissions if any.
      #--------------------------------------------------------------------------
      def update_with_permissions(attributes, _users = nil)
        ActiveSupport::Deprecation.warn "update_with_permissions is deprecated and may be removed from future releases, use user_ids and group_ids inside attributes instead."
        update_attributes(attributes)
      end

      # Save the model copying other model's permissions.
      #--------------------------------------------------------------------------
      def save_with_model_permissions(model)
        self.access    = model.access
        self.user_ids  = model.user_ids
        self.group_ids = model.group_ids
        save
      end
    end

    module SingletonMethods
    end
  end # Permissions
end # FatFreeCRM

ActiveRecord::Base.send(:include, FatFreeCRM::Permissions)
