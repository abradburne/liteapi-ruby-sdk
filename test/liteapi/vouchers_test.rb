# frozen_string_literal: true

require 'test_helper'

class VouchersTest < Minitest::Test
  include LiteapiTestHelper

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_vouchers
    stub_liteapi_request(:get, 'vouchers',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 1, 'voucher_code' => 'SAVE10', 'discount_value' => 10 }
        ]
      })

    result = @client.vouchers

    assert_kind_of Array, result
  end

  def test_voucher
    stub_liteapi_request(:get, 'vouchers/42',
      response_body: {
        'status' => 'success',
        'data' => { 'id' => 42, 'voucher_code' => 'SAVE10' }
      })

    result = @client.voucher(42)

    assert_kind_of Hash, result
    assert_equal 42, result['id']
  end

  def test_create_voucher
    stub_request(:post, 'https://api.liteapi.travel/v3.0/vouchers')
      .with(
        body: hash_including(
          'voucher_code' => 'SUMMER20',
          'discount_type' => 'percentage',
          'discount_value' => 20
        )
      )
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'message' => 'Voucher created successfully', 'id' => 99 }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.create_voucher(
      voucher_code: 'SUMMER20',
      discount_type: 'percentage',
      discount_value: 20,
      minimum_spend: 100,
      maximum_discount_amount: 50,
      currency: 'USD',
      validity_start: '2025-06-01',
      validity_end: '2025-08-31',
      usages_limit: 100,
      status: 'active'
    )

    assert_kind_of Hash, result
  end

  def test_update_voucher
    stub_request(:put, 'https://api.liteapi.travel/v3.0/vouchers/42')
      .with(body: hash_including('voucher_code' => 'SUMMER25'))
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'message' => 'Voucher updated successfully' }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.update_voucher(
      42,
      voucher_code: 'SUMMER25',
      discount_type: 'percentage',
      discount_value: 25,
      minimum_spend: 100,
      maximum_discount_amount: 75,
      currency: 'USD',
      validity_start: '2025-06-01',
      validity_end: '2025-08-31',
      usages_limit: 200,
      status: 'active'
    )

    assert_kind_of Hash, result
  end

  def test_update_voucher_status
    stub_request(:put, 'https://api.liteapi.travel/v3.0/vouchers/42/status')
      .with(body: { 'status' => 'inactive' })
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => { 'message' => 'Voucher status updated successfully' }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.update_voucher_status(42, status: 'inactive')

    assert_kind_of Hash, result
  end
end
