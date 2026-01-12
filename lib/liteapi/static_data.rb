# frozen_string_literal: true

module Liteapi
  module StaticData
    # Returns list of all countries with ISO-2 codes
    def countries
      get('data/countries')
    end

    # Returns list of cities for a country
    #
    # @example
    #   client.cities(country_code: 'IT')
    def cities(**params)
      get('data/cities', prepare_query_params(params))
    end

    # Search for places and areas
    #
    # @example
    #   client.places(query: 'Rome')
    #   client.places(query: 'Rome', type: 'hotel', language: 'it')
    def places(query:, **params)
      params[:text_query] = query
      params[:language] ||= 'en'
      get('data/places', prepare_query_params(params))
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
    # Supports multiple search approaches: by city, coordinates, place ID, or hotel IDs.
    # All parameters are passed through to the API with snake_case converted to camelCase.
    #
    # @example Search by country and city
    #   client.hotels(country_code: 'IT', city_name: 'Rome')
    #
    # @example Search by hotel IDs
    #   client.hotels(hotel_ids: ['lp1234', 'lp5678'])
    #
    # @example AI-powered search
    #   client.hotels(ai_search: 'luxury beach resort with pool')
    #
    # @example Search by place ID
    #   client.hotels(place_id: 'place_abc123')
    def hotels(**params)
      params[:language] ||= 'en'
      get('data/hotels', prepare_query_params(params))
    end

    # Get detailed hotel information
    #
    # @example
    #   client.hotel('lp1897')
    #   client.hotel('lp1897', language: 'fr')
    def hotel(hotel_id, **params)
      params[:hotel_id] = hotel_id
      get('data/hotel', prepare_query_params(params))
    end

    # Get hotel reviews with optional sentiment analysis
    #
    # @example
    #   client.hotel_reviews(hotel_id: 'lp1897')
    #   client.hotel_reviews(hotel_id: 'lp1897', limit: 100, get_sentiment: true)
    def hotel_reviews(hotel_id:, **params)
      params[:hotel_id] = hotel_id
      get('data/reviews', prepare_query_params(params))
    end
  end
end
