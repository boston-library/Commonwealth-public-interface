# various app-specific config settings

GOOGLE_ANALYTICS = YAML.load_file(Rails.root.join('config', 'google_analytics.yml'))[Rails.env]

CONTACT_EMAILS = YAML.load_file(Rails.root.join('config', 'contact_emails.yml'))[Rails.env]

IIIF_SERVER = YAML.load_file(Rails.root.join('config', 'iiif_server.yml'))[Rails.env]

GEOJSON_STATIC_FILE = YAML.load_file(Rails.root.join('config', 'geojson_static_file.yml'))[Rails.env]