# frozen_string_literal: true

Deprecation.default_deprecation_behavior = :silence if Rails.env.production? || Rails.env.staging?
