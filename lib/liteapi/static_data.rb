# frozen_string_literal: true

module Liteapi
  module StaticData
    # Returns list of all countries with ISO-2 codes
    def countries
      get('data/countries')
    end

    # Returns list of cities for a country
    #
    # @param country_code [String] ISO-2 country code (e.g., 'SG', 'US')
    def cities(country_code:)
      get('data/cities', countryCode: country_code)
    end

    # Search for places and areas
    #
    # @param query [String] Search text (e.g., 'Rome', 'Manhattan')
    # @param type [String, nil] Filter by place type (e.g., 'hotel')
    # @param language [String] Language for results (default: 'en')
    def places(query:, type: nil, language: 'en')
      params = { textQuery: query, language: language }
      params[:type] = type if type
      get('data/places', params)
    end

    # Returns all available currency codes
    def currencies
      get('data/currencies')
    end

    # Returns IATA codes for all airports
    def iata_codes
      get('data/iataCodes')
    end

    # Returns list of hotel facility types
    def hotel_facilities
      get('data/facilities')
    end

    # Returns list of hotel types (Hotel, Hostel, Resort, etc.)
    def hotel_types
      get('data/hotelTypes')
    end

    # Returns list of hotel chains
    def hotel_chains
      get('data/chains')
    end

    # Search for hotels
    #
    # @param country_code [String] ISO-2 country code (required)
    # @param city_name [String, nil] Filter by city name
    # @param latitude [Float, nil] Latitude for geo search
    # @param longitude [Float, nil] Longitude for geo search
    # @param radius [Integer, nil] Search radius in km (for geo search)
    # @param language [String] Language for results (default: 'en')
    def hotels(country_code:, city_name: nil, latitude: nil, longitude: nil, radius: nil, language: 'en')
      params = { countryCode: country_code, language: language }
      params[:cityName] = city_name if city_name
      params[:latitude] = latitude if latitude
      params[:longitude] = longitude if longitude
      params[:radius] = radius if radius
      get('data/hotels', params)
    end

    # Get detailed hotel information
    #
    # @param hotel_id [String] Hotel identifier
    # @param language [String, nil] Language for results
    def hotel(hotel_id, language: nil)
      params = { hotelId: hotel_id }
      params[:language] = language if language
      get('data/hotel', params)
    end

    # Get hotel reviews with optional sentiment analysis
    #
    # @param hotel_id [String] Hotel identifier
    # @param limit [Integer, nil] Maximum reviews to return (max 1000)
    # @param sentiment [Boolean] Include sentiment analysis
    def hotel_reviews(hotel_id:, limit: nil, sentiment: false)
      params = { hotelId: hotel_id }
      params[:limit] = limit if limit
      params[:getSentiment] = sentiment if sentiment
      get('data/reviews', params)
    end
  end
end
