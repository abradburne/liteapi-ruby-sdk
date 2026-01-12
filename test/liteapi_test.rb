# frozen_string_literal: true

require 'test_helper'

class LiteapiTest < Minitest::Test
  def test_version_exists
    refute_nil Liteapi::VERSION
  end

  def test_configure_block
    Liteapi.configure do |config|
      config.api_key = 'test_key'
      config.timeout = 60
    end

    assert_equal 'test_key', Liteapi.configuration.api_key
    assert_equal 60, Liteapi.configuration.timeout
  end

  def test_reset_configuration
    # Temporarily unset env var for this test
    original_key = ENV['LITEAPI_API_KEY']
    ENV.delete('LITEAPI_API_KEY')

    Liteapi.reset_configuration!
    Liteapi.configure { |c| c.api_key = 'test_key' }
    Liteapi.reset_configuration!

    assert_nil Liteapi.configuration.api_key
  ensure
    ENV['LITEAPI_API_KEY'] = original_key if original_key
    Liteapi.reset_configuration!
  end

  def test_default_configuration_values
    config = Liteapi::Configuration.new

    assert_equal 'https://api.liteapi.travel/v3.0', config.base_url
    assert_equal 30, config.timeout
    assert_equal 10, config.open_timeout
    assert_equal 3, config.max_retries
  end
end
