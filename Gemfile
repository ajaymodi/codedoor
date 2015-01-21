source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Moving over to postgresql as that is what we will be using in production
gem 'pg', '~> 0.17.0'

gem 'puma', '~> 2.6.0'

# Use CanCan for authorization
gem 'cancan', '~> 1.6.10'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails', '~> 1.1.2'
gem 'bootstrap-sass', '~> 2.3.2.1'

# Use slim for templating
gem 'slim', '~> 2.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Adding the balanced ruby gem so we can associate card URIs with customers
gem 'balanced', '~> 0.7.4'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.0.4'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 1.3.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.5.1'

# GitHub oAuth is used for login, and omniauth is used with devise
gem 'devise', '~> 3.0.1'
gem 'omniauth-github', '~> 1.1.1'

# Manage environment variables related to this application
gem 'figaro', '~> 0.7.0'

gem 'nested_form', '~> 0.3.2'

gem 'github_api', '~> 0.10.1'

gem 'state_machine', '~> 1.2.0'

gem 'will_paginate', '~> 3.0'

# Danpal's fork of attr_encrypted
gem 'attr_encryptor'

# Right now, only used for the edge case where there are over 100 contributors
gem 'rest-client', '~> 1.6.7'

gem 'intercom-rails', '~> 0.2.22'

gem 'google-analytics-rails', '~> 0.0.4'

gem 'newrelic_rpm'

gem 'sitemap_generator', '~> 4.2.0'

gem 'rails_autolink', '~> 1.1.5'

# Interacting with AWS
gem 'fog', '~> 1.18.0'

gem 'rack-affiliates', '~> 0.2.0'

group :development do
  gem 'bullet'
end

group :development, :test do
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rspec-mocks'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'fakeweb'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production, :staging do
  # Used by Heroku
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
