source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0', '>= 5.0.0.1'

case ENV['CI'] && ENV['DB']
when "mysql"; gem "mysql2"
when "sqlite"; gem "sqlite3"
when "postgres"; gem "pg"
else
  # gem 'mysql2'
  # gem 'sqlite3'
  gem 'pg'
end

# Removes a gem dependency
def remove(name)
  @dependencies.reject! { |d| d.name == name }
end

# Replaces an existing gem dependency (e.g. from gemspec) with an alternate source.
def gem(name, *args)
  remove(name)
  super
end

##BUG in rails-observers needs to be fixed see https://github.com/rails/rails-observers/issues/45
gem 'rails-observers', :git => 'http://github.com/rails/rails-observers.git', :branch => 'master'
gem 'sprockets', git: 'http://github.com/rails/sprockets.git'
gem 'sprockets-rails', git: 'http://github.com/rails/sprockets-rails.git' #'~> 3.2.0'
gem 'ransack', git: 'http://github.com/activerecord-hackery/ransack.git'
gem 'will_paginate', '~> 3.1.1'

#Rails5 xml serializer is separated out
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'

# (See https://github.com/carlhuda/bundler/issues/1041)
spec = Bundler.load_gemspec(File.expand_path("../fat_free_crm.gemspec", __FILE__))
spec.runtime_dependencies.each do |dep|
  gem dep.name, *(dep.requirement.as_list)
end

# Remove premailer auto-require
gem 'premailer', require: false

# Remove fat_free_crm dependency, to stop it from being auto-required too early.
remove 'fat_free_crm'

group :development do
  # don't load these gems in travis
  unless ENV["CI"]
    gem 'thin'
    #gem 'quiet_assets' SP-TODO: config.assets.quiet = true
    gem 'capistrano'
    gem 'capistrano-bundler'
    gem 'capistrano-rails'
    gem 'capistrano-rvm'
    #~ gem 'capistrano-chruby'
    #~ gem 'capistrano-rbenv'
    gem 'guard'
    gem 'guard-rspec'
    gem 'guard-rails'
    gem 'rb-inotify', require: false
    gem 'rb-fsevent', require: false
    gem 'rb-fchange', require: false
  end
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-activemodel-mocks'
  gem 'headless'
  gem 'byebug'
  gem 'pry-rails' unless ENV["CI"]
  gem 'factory_girl_rails'
end

group :test do
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem "acts_as_fu"
  gem 'zeus' unless ENV["CI"]
  gem 'timecop'
end

group :heroku do
  gem 'unicorn', platform: :ruby
  gem 'rails_12factor'
end

## must run with sass-rails 6.0, but this is still beta and it doesnt support
## railties 5.0 and higher. But railties 5.0 is higher is required by rails5.0
## so make local copy and change gemspec to add railties 5.0
gem 'sass-rails', path: '../sass-rails'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
gem 'execjs'
gem 'therubyracer', platform: :ruby unless ENV["CI"]
gem 'nokogiri', '>= 1.6.8'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

