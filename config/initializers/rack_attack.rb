Rack::Attack.safelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  '127.0.0.1' == req.ip || '::1' == req.ip
end

Rack::Attack.blocklist('allow2ban download scrapers') do |req|
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 10, findtime: 1.minute, bantime: 1.day) do
    req.path.include?('/start_download/')
  end
end

ActiveSupport::Notifications.subscribe(/rack_attack/) do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  Rails.logger.info '--------------------------------------------------------------'
  Rails.logger.info 'Request Info:'
  Rails.logger.info "<Request Name: #{event.name}; ID: #{event.transaction_id}; Duration: #{event.duration} />"
  Rails.logger.info "< #{event.payload.inspect} />"
  Rails.logger.info '--------------------------------------------------------------'
end
