# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'liteapi'

require 'minitest/autorun'
require 'webmock/minitest'

WebMock.disable_net_connect!

module LiteapiTestHelper
  BASE_URL = 'https://api.liteapi.travel/v3.0'

  def setup
    Liteapi.reset_configuration!
    WebMock.reset!
  end

  def stub_liteapi_request(method, path, response_body:, status: 200, query: nil)
    url = "#{BASE_URL}/#{path}"
    stub = stub_request(method, url)
    stub = stub.with(query: hash_including(query)) if query
    stub.to_return(
      status: status,
      body: response_body.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
