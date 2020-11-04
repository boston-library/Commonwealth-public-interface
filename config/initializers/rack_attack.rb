Rack::Attack.safelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  ['127.0.0.1', '::1'].include?(req.ip)
end

Rack::Attack.throttle("requests by ip", limit: 10, period: 1.minute) do |req|
  req.ip if req.path.include?('/start_download/')
end

Rack::Attack.throttled_response_retry_after_header = true

Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]

  headers = {
    'RateLimit-Limit' => match_data[:limit].to_s,
    'RateLimit-Remaining' => '0',
    'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
  }

  [ 429, headers, ["Throttled\n"]]
end

ActiveSupport::Notifications.subscribe('throttle.rack_attack') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)

  Rails.logger.warn '--------------------------------------------------------------'
  Rails.logger.warn 'WARN: Client exceeded rate limit'
  Rails.logger.warn 'Request Info:'
  Rails.logger.warn "<Request Name: #{event.name}; ID: #{event.transaction_id}; Duration: #{event.duration} />"
  Rails.logger.warn "< #{event.payload.inspect} />"
  Rails.logger.warn '--------------------------------------------------------------'
end
