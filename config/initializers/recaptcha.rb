# frozen_string_literal: true

Recaptcha.configure do |config|
  config.site_key = ENV.fetch('RECAPTCHA_SITE_KEY') { Rails.application.credentials.dig(:recaptcha, :site_key] }
  config.secret_key = ENV.fetch('RECAPTCHA_SECRET_KEY') { Rails.application.credentials.dig(:recaptcha, :secret_key) }
end
