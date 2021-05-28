# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '6.0.3.4'

gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '>= 3.12.4', '< 5'
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
gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine', branch: 'dc3'
# gem 'bpluser', path: '/Users/eben/Documents/Work/BPL/boston-library/bpluser'
gem 'bpluser', github: 'boston-library/bpluser'

gem 'rack-attack', '~> 6.3'

gem 'dotenv-rails', '~> 2.7'
# rubocop has to be loaded in production, or rake commands fail
gem 'rubocop', '~> 0.75.1'
gem 'rubocop-performance', '~> 1.5'
gem 'rubocop-rails', '~> 2.4.2'
gem 'rubocop-rspec'

group :development, :test do
  gem 'awesome_print'
  gem 'coveralls', require: false
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'sqlite3', '~> 1.4'
  gem 'rspec-rails', '~> 3.9', '< 4.0'
  gem 'capybara', '~> 3.0', '< 4'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'webdrivers', '~> 3.0'
end
