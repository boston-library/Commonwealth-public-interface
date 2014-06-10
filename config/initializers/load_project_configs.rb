# various app-specific config settings

GOOGLE_ANALYTICS = YAML.load_file(Rails.root.join('config', 'google_analytics.yml'))[Rails.env]

CONTACT_EMAILS = YAML.load_file(Rails.root.join('config', 'contact_emails.yml'))[Rails.env]