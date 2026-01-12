# frozen_string_literal: true

require 'test_helper'

class StaticDataTest < Minitest::Test
  include LiteapiTestHelper

  def setup
    super
    Liteapi.configure { |c| c.api_key = 'test_api_key' }
    @client = Liteapi::Client.new
  end

  def test_countries
    stub_liteapi_request(:get, 'data/countries',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'name' => 'Singapore', 'isoCode' => 'SG' },
          { 'name' => 'United States', 'isoCode' => 'US' }
        ]
      })

    result = @client.countries

    assert_kind_of Array, result
    assert_equal 'Singapore', result.first['name']
  end

  def test_cities
    stub_liteapi_request(:get, 'data/cities',
      query: { 'countryCode' => 'SG' },
      response_body: {
        'status' => 'success',
        'data' => [
          { 'name' => 'Singapore' }
        ]
      })

    result = @client.cities(country_code: 'SG')

    assert_kind_of Array, result
  end

  def test_places
    stub_liteapi_request(:get, 'data/places',
      query: { 'textQuery' => 'Rome', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => [
          { 'name' => 'Rome, Italy' }
        ]
      })

    result = @client.places(query: 'Rome')

    assert_kind_of Array, result
  end

  def test_places_with_type
    stub_liteapi_request(:get, 'data/places',
      query: { 'textQuery' => 'Rome', 'language' => 'en', 'type' => 'hotel' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.places(query: 'Rome', type: 'hotel')

    assert_kind_of Array, result
  end

  def test_currencies
    stub_liteapi_request(:get, 'data/currencies',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'code' => 'USD', 'name' => 'US Dollar' }
        ]
      })

    result = @client.currencies

    assert_kind_of Array, result
  end

  def test_iata_codes
    stub_liteapi_request(:get, 'data/iataCodes',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'code' => 'SIN', 'name' => 'Singapore Changi' }
        ]
      })

    result = @client.iata_codes

    assert_kind_of Array, result
  end

  def test_hotel_facilities
    stub_liteapi_request(:get, 'data/facilities',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 1, 'name' => 'WiFi' }
        ]
      })

    result = @client.hotel_facilities

    assert_kind_of Array, result
  end

  def test_hotel_types
    stub_liteapi_request(:get, 'data/hotelTypes',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 1, 'name' => 'Hotel' }
        ]
      })

    result = @client.hotel_types

    assert_kind_of Array, result
  end

  def test_hotel_chains
    stub_liteapi_request(:get, 'data/chains',
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 1, 'name' => 'Marriott' }
        ]
      })

    result = @client.hotel_chains

    assert_kind_of Array, result
  end

  def test_hotels
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'countryCode' => 'IT', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 'lp1234', 'name' => 'Grand Hotel' }
        ]
      })

    result = @client.hotels(country_code: 'IT')

    assert_kind_of Array, result
  end

  def test_hotels_with_city
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'countryCode' => 'IT', 'cityName' => 'Rome', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.hotels(country_code: 'IT', city_name: 'Rome')

    assert_kind_of Array, result
  end

  def test_hotels_with_hotel_ids
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'hotelIds' => 'lp1234,lp5678', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => [
          { 'id' => 'lp1234' },
          { 'id' => 'lp5678' }
        ]
      })

    result = @client.hotels(hotel_ids: %w[lp1234 lp5678])

    assert_kind_of Array, result
    assert_equal 2, result.size
  end

  def test_hotels_with_ai_search
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'aiSearch' => 'luxury beach resort', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.hotels(ai_search: 'luxury beach resort')

    assert_kind_of Array, result
  end

  def test_hotels_with_place_id
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'placeId' => 'place_abc123', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.hotels(place_id: 'place_abc123')

    assert_kind_of Array, result
  end

  def test_hotels_with_chain_ids
    stub_liteapi_request(:get, 'data/hotels',
      query: { 'chainIds' => '1,2,3', 'language' => 'en' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.hotels(chain_ids: %w[1 2 3])

    assert_kind_of Array, result
  end

  def test_hotel
    stub_liteapi_request(:get, 'data/hotel',
      query: { 'hotelId' => 'lp1897' },
      response_body: {
        'status' => 'success',
        'data' => { 'id' => 'lp1897', 'name' => 'Test Hotel' }
      })

    result = @client.hotel('lp1897')

    assert_kind_of Hash, result
    assert_equal 'lp1897', result['id']
  end

  def test_hotel_with_language
    stub_liteapi_request(:get, 'data/hotel',
      query: { 'hotelId' => 'lp1897', 'language' => 'fr' },
      response_body: {
        'status' => 'success',
        'data' => { 'id' => 'lp1897' }
      })

    result = @client.hotel('lp1897', language: 'fr')

    assert_kind_of Hash, result
  end

  def test_hotel_reviews
    stub_liteapi_request(:get, 'data/reviews',
      query: { 'hotelId' => 'lp1897' },
      response_body: {
        'status' => 'success',
        'data' => [
          { 'rating' => 5, 'text' => 'Great stay!' }
        ]
      })

    result = @client.hotel_reviews(hotel_id: 'lp1897')

    assert_kind_of Array, result
  end

  def test_hotel_reviews_with_options
    stub_liteapi_request(:get, 'data/reviews',
      query: { 'hotelId' => 'lp1897', 'limit' => '5', 'getSentiment' => 'true' },
      response_body: {
        'status' => 'success',
        'data' => []
      })

    result = @client.hotel_reviews(hotel_id: 'lp1897', limit: 5, get_sentiment: true)

    assert_kind_of Array, result
  end
end
