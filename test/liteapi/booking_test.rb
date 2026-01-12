# frozen_string_literal: true

require 'test_helper'

class BookingTest < Minitest::Test
  include LiteapiTestHelper

  BOOK_BASE_URL = 'https://book.liteapi.travel/v3.0'

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_prebook
    stub_request(:post, "#{BOOK_BASE_URL}/rates/prebook")
      .with(body: hash_including('offerId' => 'offer_123'))
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => {
            'prebookId' => 'prebook_456',
            'offerId' => 'offer_123'
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.prebook(offer_id: 'offer_123')

    assert_kind_of Hash, result
    assert_equal 'prebook_456', result['prebookId']
  end

  def test_book
    stub_request(:post, "#{BOOK_BASE_URL}/rates/book")
      .with(
        body: hash_including('prebookId' => 'prebook_456')
      )
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => {
            'bookingId' => 'booking_789',
            'status' => 'confirmed'
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.book(
      prebook_id: 'prebook_456',
      guest_info: {
        guest_first_name: 'John',
        guest_last_name: 'Doe',
        guest_email: 'john@example.com'
      },
      payment_method: {
        holder_name: 'John Doe',
        card_number: '4111111111111111',
        expire_date: '12/25',
        cvc: '123'
      }
    )

    assert_kind_of Hash, result
    assert_equal 'booking_789', result['bookingId']
  end

  def test_bookings
    stub_request(:get, "#{BOOK_BASE_URL}/bookings")
      .with(query: hash_including('clientReference' => 'my-ref-123'))
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => [
            { 'bookingId' => 'booking_789' }
          ]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.bookings(client_reference: 'my-ref-123')

    assert_kind_of Array, result
  end

  def test_booking
    stub_request(:get, "#{BOOK_BASE_URL}/bookings/booking_789")
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => {
            'bookingId' => 'booking_789',
            'status' => 'confirmed'
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.booking('booking_789')

    assert_kind_of Hash, result
    assert_equal 'booking_789', result['bookingId']
  end

  def test_cancel_booking
    stub_request(:put, "#{BOOK_BASE_URL}/bookings/booking_789")
      .to_return(
        status: 200,
        body: {
          'status' => 'success',
          'data' => {
            'bookingId' => 'booking_789',
            'status' => 'cancelled'
          }
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.cancel_booking('booking_789')

    assert_kind_of Hash, result
    assert_equal 'cancelled', result['status']
  end
end
