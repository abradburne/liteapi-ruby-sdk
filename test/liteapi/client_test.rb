# frozen_string_literal: true

require 'test_helper'

class ClientTest < Minitest::Test
  include LiteapiTestHelper

  def test_requires_api_key
    # Temporarily unset env var for this test
    original_key = ENV['LITEAPI_API_KEY']
    ENV.delete('LITEAPI_API_KEY')
    Liteapi.reset_configuration!

    error = assert_raises(Liteapi::Error) do
      Liteapi::Client.new
    end

    assert_match(/API key is required/, error.message)
  ensure
    ENV['LITEAPI_API_KEY'] = original_key if original_key
    Liteapi.reset_configuration!
  end

  def test_accepts_api_key_as_argument
    client = Liteapi::Client.new(api_key: 'test_key')

    assert_equal 'test_key', client.api_key
  end

  def test_uses_configured_api_key
    Liteapi.configure { |c| c.api_key = 'configured_key' }
    client = Liteapi::Client.new

    assert_equal 'configured_key', client.api_key
  end

  def test_argument_overrides_configuration
    Liteapi.configure { |c| c.api_key = 'configured_key' }
    client = Liteapi::Client.new(api_key: 'override_key')

    assert_equal 'override_key', client.api_key
  end

  def test_accepts_custom_base_url
    client = Liteapi::Client.new(api_key: 'key', base_url: 'https://custom.api.com')

    assert_equal 'https://custom.api.com', client.base_url
  end

  def test_accepts_custom_timeout
    client = Liteapi::Client.new(api_key: 'key', timeout: 60)

    assert_equal 60, client.timeout
  end
end
