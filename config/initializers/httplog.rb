# frozen_string_literal: true

if Rails.env.development?
  HttpLog.configure do |config|
    # Enable or disable all logging
    config.enabled = Rails.env.development?

    # You can assign a different logger
    config.logger = Logger.new($stdout)

    # I really wouldn't change this...
    config.severity = Logger::Severity::DEBUG

    # Tweak which parts of the HTTP cycle to log...
    config.log_connect = true
    config.log_request = true
    config.log_headers = false
    config.log_data = true
    config.log_status = true
    config.log_response = true
    config.log_benchmark = true

    # ...or log all request as a single line by setting this to `true`
    config.compact_log = false

    # You can also log in JSON format
    config.json_log = true

    # Prettify the output - see below
    config.color = false

    # Limit logging based on URL patterns
    config.url_whitelist_pattern = nil
    config.url_blacklist_pattern = nil
  end
end
