# frozen_string_literal: true

require 'test_helper'

class ErrorsTest < Minitest::Test
  include LiteapiTestHelper

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_authentication_error_on_401
    stub_liteapi_request(:get, 'data/countries',
      status: 401,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Invalid API key', 'code' => 401 }
      })

    error = assert_raises(Liteapi::AuthenticationError) do
      @client.countries
    end

    assert_equal 401, error.status
    assert_equal 'Invalid API key', error.message
  end

  def test_not_found_error_on_404
    stub_liteapi_request(:get, 'data/hotel',
      query: { 'hotelId' => 'invalid' },
      status: 404,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Hotel not found', 'code' => 404 }
      })

    error = assert_raises(Liteapi::NotFoundError) do
      @client.hotel('invalid')
    end

    assert_equal 404, error.status
  end

  def test_rate_limit_error_on_429
    stub_liteapi_request(:get, 'data/countries',
      status: 429,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Rate limit exceeded', 'code' => 429 }
      })

    # Disable retries for this test
    client = Liteapi::Client.new(api_key: 'test', max_retries: 0)

    error = assert_raises(Liteapi::RateLimitError) do
      client.countries
    end

    assert_equal 429, error.status
  end

  def test_validation_error_on_422
    stub_liteapi_request(:get, 'data/cities',
      query: { 'countryCode' => 'INVALID' },
      status: 422,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Invalid country code', 'code' => 422 }
      })

    error = assert_raises(Liteapi::ValidationError) do
      @client.cities(country_code: 'INVALID')
    end

    assert_equal 422, error.status
  end

  def test_server_error_on_500
    stub_liteapi_request(:get, 'data/countries',
      status: 500,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Internal server error' }
      })

    # Disable retries for this test
    client = Liteapi::Client.new(api_key: 'test', max_retries: 0)

    error = assert_raises(Liteapi::ServerError) do
      client.countries
    end

    assert_equal 500, error.status
  end

  def test_error_includes_response
    stub_liteapi_request(:get, 'data/countries',
      status: 400,
      response_body: {
        'status' => 'failed',
        'error' => { 'message' => 'Bad request', 'code' => 400, 'details' => 'Missing param' }
      })

    error = assert_raises(Liteapi::ClientError) do
      @client.countries
    end

    assert_equal 400, error.response.dig('error', 'code')
    assert_equal 'Missing param', error.response.dig('error', 'details')
  end
end
