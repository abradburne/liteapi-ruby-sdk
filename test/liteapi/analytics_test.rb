# frozen_string_literal: true

require 'test_helper'

class AnalyticsTest < Minitest::Test
  include LiteapiTestHelper

  DASHBOARD_BASE_URL = 'https://da.liteapi.travel'

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_weekly_analytics
    stub_request(:post, "#{DASHBOARD_BASE_URL}/analytics/weekly")
      .with(body: { 'from' => '2025-01-01', 'to' => '2025-01-07' })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'totalBookings' => 150, 'totalRevenue' => 25000 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.weekly_analytics(from: '2025-01-01', to: '2025-01-07')

    assert_kind_of Hash, result
    assert_equal 150, result['totalBookings']
  end

  def test_analytics_report
    stub_request(:post, "#{DASHBOARD_BASE_URL}/analytics/report")
      .with(body: { 'from' => '2025-01-01', 'to' => '2025-01-31' })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'totalRevenue' => 100000, 'salesRevenue' => 95000 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.analytics_report(from: '2025-01-01', to: '2025-01-31')

    assert_kind_of Hash, result
  end

  def test_market_analytics
    stub_request(:post, "#{DASHBOARD_BASE_URL}/analytics/market")
      .with(body: { 'from' => '2025-01-01', 'to' => '2025-01-31' })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'markets' => [{ 'country' => 'US', 'bookings' => 500 }] }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.market_analytics(from: '2025-01-01', to: '2025-01-31')

    assert_kind_of Hash, result
  end

  def test_most_booked_hotels
    stub_request(:post, "#{DASHBOARD_BASE_URL}/analytics/top-hotels")
      .with(body: { 'from' => '2025-01-01', 'to' => '2025-01-31' })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => [
            { 'hotelId' => 'lp1234', 'bookings' => 50 },
            { 'hotelId' => 'lp5678', 'bookings' => 45 }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.most_booked_hotels(from: '2025-01-01', to: '2025-01-31')

    assert_kind_of Array, result
    assert_equal 2, result.size
  end
end
