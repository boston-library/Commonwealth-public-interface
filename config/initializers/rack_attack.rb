# frozen_string_literal: true

Rack::Attack.safelist('allow from localhost') do |req|
  # Requests are allowed if the return value is truthy
  ['127.0.0.1', '::1'].include?(req.ip)
end

Rack::Attack.throttle('requests by ip', limit: 10, period: 1.minute) do |req|
  req.ip if req.path.include?('/start_download/')
end

Rack::Attack.throttled_responder = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]
  retry_after = match_data[:period] - (now % match_data[:period])

  headers = {
    'Content-Type' => 'text/plain',
    'Retry-After' => retry_after.to_s,
    'RateLimit-Limit' => match_data[:limit].to_s,
    'RateLimit-Remaining' => '0'
  }

  [429, headers, ["Retry later\n"]]
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
