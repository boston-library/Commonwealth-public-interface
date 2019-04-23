source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '5.2.2'

gem 'pg', '>= 0.18', '< 2.0'

gem 'sass-rails',   '~> 5.0'
gem 'coffee-rails', '~> 4.2'

gem 'uglifier', '>= 1.3.0'

gem 'turbolinks', '~> 5'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'jquery-rails', '~> 4.3', '>= 4.3.1'
gem 'jquery-ui-rails', '~> 6.0', '>= 6.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
gem 'jbuilder', '~> 2.5'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#various utilities
# gem 'libv8', '~> 3.16.14.3'
# gem 'therubyracer'

gem 'mini_racer', platforms: :ruby

# blacklight
# gem 'blacklight', '6.7.0'

#gem 'commonwealth-vlr-engine', :path => '/home/eenglish/boston-library/commonwealth-vlr-engine'
gem 'commonwealth-vlr-engine', github: 'boston-library/commonwealth-vlr-engine'
#gem 'blacklight-maps', :path => '/home/eenglish/boston-library/blacklight-maps'
#gem 'blacklight-maps', :git => 'https://github.com/boston-library/blacklight-maps', :branch => 'fix-initialzoom-option'

gem 'blacklight_iiif_search', '~> 0.0.2.pre.alpha'

# can't use 3.3.5
gem 'bootstrap-sass', '>= 3.3.5.1', '< 4'

# gem 'devise', '~> 3.4.1'
gem 'web-console', '~> 2.0', group: :development

group :development, :test do
  gem 'awesome_print'
  gem 'pry'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'sqlite3', '~> 1.3', '>= 1.3.11', "< 1.4.0"
  gem 'rspec-rails', '~> 3.8.0'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem  'puma', '~> 3.11.4'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
