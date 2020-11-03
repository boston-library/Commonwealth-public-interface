Rack::Attack.safelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  '127.0.0.1' == req.ip || '::1' == req.ip
end

Rack::Attack.throttle('download-requests-by-ip', limit: 10, period: 1.minute) do |req|
  req.ip if req.path.include?('/start_download/')
end

ActiveSupport::Notifications.subscribe("throttle.rack_attack") do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  Rails.logger.info '--------------------------------------------------------------'
  Rails.logger.info 'Client Throttled after going over the download request limit'
  Rails.logger.info 'Client Info:'
  Rails.logger.info "<Request Name: #{event.name}; ID: #{event.transaction_id}; Duration: #{event.duration} />"
  Rails.logger.info "< #{event.payload.inspect} />"
  Rails.logger.info '--------------------------------------------------------------'
end
