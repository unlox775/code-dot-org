# frozen_string_literal: true

require 'request_store'

Rails.application.configure do
  config.lograge.custom_options = lambda do |event|
    request_id = event.payload[:request_id] || RequestStore.store[:request_id]
    cloudfront_request_id = RequestStore.store[:cloudfront_request_id]

    {}.tap do |options|
      options[:request_id] = request_id if request_id
      options[:cloudfront_request_id] = cloudfront_request_id if cloudfront_request_id
    end
  end
end
