# frozen_string_literal: true

require 'test_helper'

class GuestsTest < Minitest::Test
  include LiteapiTestHelper

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_loyalty
    stub_liteapi_request(:get, 'guests/loyalty',
      response_body: {
        'status' => 'success',
        'data' => { 'status' => 'enabled', 'cashbackRate' => 0.03 }
      })

    result = @client.loyalty

    assert_kind_of Hash, result
    assert_equal 'enabled', result['status']
  end

  def test_enable_loyalty
    stub_request(:post, 'https://api.liteapi.travel/v3.0/guests/loyalty')
      .with(body: { 'status' => 'enabled', 'cashbackRate' => 0.05 })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'status' => 'enabled', 'cashbackRate' => 0.05 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.enable_loyalty(status: 'enabled', cashback_rate: 0.05)

    assert_kind_of Hash, result
  end

  def test_update_loyalty
    stub_request(:put, 'https://api.liteapi.travel/v3.0/guests/loyalty')
      .with(body: { 'status' => 'disabled', 'cashbackRate' => 0.02 })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'status' => 'disabled', 'cashbackRate' => 0.02 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.update_loyalty(status: 'disabled', cashback_rate: 0.02)

    assert_kind_of Hash, result
  end

  def test_guest
    stub_liteapi_request(:get, 'guests/123',
      response_body: {
        'status' => 'success',
        'data' => { 'id' => 123, 'firstName' => 'John', 'lastName' => 'Doe' }
      })

    result = @client.guest(123)

    assert_kind_of Hash, result
    assert_equal 123, result['id']
  end

  def test_guest_bookings
    stub_liteapi_request(:get, 'guests/123/bookings',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'bookingId' => 'booking_abc', 'loyaltyPoints' => 150 }
        ]
      })

    result = @client.guest_bookings(123)

    assert_kind_of Array, result
  end
end
