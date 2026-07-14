# frozen_string_literal: true

# set this to limit expensive solr queries
Kaminari.configure do |config|
  # Restricts the total number of pages globally
  config.max_pages = 25_000
end
