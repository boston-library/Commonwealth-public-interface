# frozen_string_literal: true

# !/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

if %w(test development).member?(Rails.env)
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.requires << 'rubocop-rails'
    task.requires << 'rubocop-rspec'
    task.requires << 'rubocop-performance'
    task.fail_on_error = true
    # WARNING: Make sure the bottom 3 lines are always commented out before committing
    # task.options << '--safe-auto-correct'
    # task.options << '--disable-uncorrectable'
    # task.options << '-d'
  end

  desc 'Lint, and run test suite'
  task default: [:rubocop] # rspec runs automatically
end
