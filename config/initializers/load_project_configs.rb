# various app-specific config settings

GOOGLE_ANALYTICS = YAML.load_file(Rails.root.join('config', 'google_analytics.yml'))[Rails.env]