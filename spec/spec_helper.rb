# frozen_string_literal: true

require 'awesome_print'
if ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter 'config/'
    add_filter 'spec/'
  end
end
require 'coveralls'
Coveralls.wear!('rails')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.order = 'random'
end
