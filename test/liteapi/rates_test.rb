# frozen_string_literal: true

require 'test_helper'

class RatesTest < Minitest::Test
  include LiteapiTestHelper

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_full_rates
    stub_request(:post, 'https://api.liteapi.travel/v3.0/hotels/rates')
      .with(
        body: hash_including(
          'hotelIds' => %w[lp1234 lp5678],
          'checkin' => '2025-03-01',
          'checkout' => '2025-03-03',
          'occupancies' => [{ 'rooms' => 1, 'adults' => 2 }],
          'guestNationality' => 'US',
          'currency' => 'USD'
        )
      )
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => {
            'hotels' => [
              { 'hotelId' => 'lp1234', 'rooms' => [] }
            ]
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.full_rates(
      hotel_ids: %w[lp1234 lp5678],
      checkin: '2025-03-01',
      checkout: '2025-03-03',
      occupancies: [{ rooms: 1, adults: 2 }],
      guest_nationality: 'US',
      currency: 'USD'
    )

    assert_kind_of Hash, result
  end

  def test_full_rates_with_children
    stub_request(:post, 'https://api.liteapi.travel/v3.0/hotels/rates')
      .with(
        body: hash_including(
          'hotelIds' => ['lp1234'],
          'occupancies' => [{ 'rooms' => 1, 'adults' => 2, 'children' => [5, 10] }]
        )
      )
      .to_return(
        status: 200,
        body: { 'status' => 'success', 'data' => {} }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.full_rates(
      hotel_ids: ['lp1234'],
      checkin: '2025-03-01',
      checkout: '2025-03-03',
      occupancies: [{ rooms: 1, adults: 2, children: [5, 10] }],
      guest_nationality: 'US',
      currency: 'USD'
    )

    assert_kind_of Hash, result
  end

  def test_min_rates
    stub_request(:post, 'https://api.liteapi.travel/v3.0/hotels/min-rates')
      .with(
        body: hash_including(
          'hotelIds' => %w[lp1234 lp5678],
          'checkin' => '2025-03-01',
          'checkout' => '2025-03-03',
          'occupancies' => [{ 'rooms' => 1, 'adults' => 2 }]
        )
      )
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => [
            { 'hotelId' => 'lp1234', 'minRate' => 150.00 }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.min_rates(
      hotel_ids: %w[lp1234 lp5678],
      checkin: '2025-03-01',
      checkout: '2025-03-03',
      occupancies: [{ rooms: 1, adults: 2 }],
      guest_nationality: 'US',
      currency: 'USD'
    )

    assert_kind_of Array, result
  end
end
