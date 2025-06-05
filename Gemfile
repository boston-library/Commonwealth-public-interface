# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.7'

gem 'rails', '~> 6.1.7.10'

gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 5.6.9'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.4'
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

gem 'bootstrap', '~> 4.6'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'jquery-rails'

# gem 'commonwealth-vlr-engine', path: '/path/to/local/boston-library/commonwealth-vlr-engine'
gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine'
gem 'bpluser', '~> 0.5'
# NOTE: net-http is needed for a workaround due to seeing 'warning: already initialized constant Net::ProtocRetryError'
# Issue is described here https://github.com/ruby/net-imap/issues/16#issuecomment-1423676522
gem 'net-http'
gem 'rack-attack', '~> 6.6'

gem 'sprockets-rails', '~> 3.4'

gem 'sd_notify', group: [:production, :staging]

gem 'postmark-rails', '~> 0.22'

group :development, :test do
  gem 'awesome_print'
  gem 'capistrano', '~> 3.19.2', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm'
  gem 'coveralls', require: false
  gem 'debug', platforms: %i(mri mingw x64_mingw)
  gem 'dotenv-rails', '~> 2.8', require: 'dotenv/rails-now'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'sqlite3', '~> 1.4'
  gem 'rspec-rails', '~> 6.0.3'
  gem 'capybara', '~> 3.0', '< 4'
  gem 'selenium-webdriver', '~> 4.10'
  gem 'rubocop', '~> 1.36', require: false
  gem 'rubocop-performance', '~> 1.15', require: false
  gem 'rubocop-rails', '~> 2.16', require: false
  gem 'rubocop-rspec', '~> 2.16', require: false
end

group :test do
  gem 'rails-controller-testing'
end
