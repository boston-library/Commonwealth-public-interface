# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.7'

gem 'rails', '~> 6.0.6.1', '< 6.1'

gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 5.6.5'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'bootstrap', '~> 4.0'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'jquery-rails'

# gem 'commonwealth-vlr-engine', path: '/Users/eben/Documents/Work/BPL/boston-library/commonwealth-vlr-engine'
gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine'
# gem 'bpluser', path: '/Users/eben/Documents/Work/BPL/boston-library/bpluser'
gem 'bpluser', github: 'boston-library/bpluser'

gem 'rack-attack', '~> 6.6'

gem 'sprockets-rails', '~> 3.4'

gem 'sd_notify', group: [:production, :staging]

gem 'capistrano', '~> 3.17', require: false
gem 'capistrano3-puma'
gem 'capistrano-rails', '~> 1.4', require: false
gem 'capistrano-rvm'

group :development, :test do
  gem 'awesome_print'
  gem 'coveralls', require: false
  gem 'dotenv-rails', '~> 2.8', require: 'dotenv/rails-now'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'sqlite3', '~> 1.4'
  gem 'rspec-rails', '~> 3.9', '< 4.0'
  gem 'capybara', '~> 3.0', '< 4'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers', '~> 3.0'
  gem 'rubocop', '~> 0.75.1', require: false
  gem 'rubocop-performance', '~> 1.5', require: false
  gem 'rubocop-rails', '~> 2.4.2', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rails-controller-testing'
end
