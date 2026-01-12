# frozen_string_literal: true

module Liteapi
  module Rates
    # Search for full rates and availability for hotels
    #
    # Returns all available rooms with rates, cancellation policies for a list of hotel IDs.
    # Includes loyalty rewards if guest_id is provided.
    #
    # @param hotel_ids [Array<String>] List of hotel IDs to search
    # @param checkin [String] Check-in date (YYYY-MM-DD)
    # @param checkout [String] Check-out date (YYYY-MM-DD)
    # @param occupancies [Array<Hash>] Room occupancies, each with :rooms, :adults, :children (ages array)
    # @param guest_nationality [String] Guest nationality (ISO-2)
    # @param currency [String] Currency code
    # @param guest_id [String, nil] Guest ID for loyalty pricing
    # @return [Hash] Rates and availability data
    #
    # @example
    #   client.full_rates(
    #     hotel_ids: ['lp1234', 'lp5678'],
    #     checkin: '2025-03-01',
    #     checkout: '2025-03-03',
    #     occupancies: [{ rooms: 1, adults: 2, children: [5, 10] }],
    #     guest_nationality: 'US',
    #     currency: 'USD'
    #   )
    def full_rates(hotel_ids:, checkin:, checkout:, occupancies:, guest_nationality:, currency:,
                   guest_id: nil)
      body = {
        hotelIds: hotel_ids,
        checkin: checkin,
        checkout: checkout,
        occupancies: occupancies,
        guestNationality: guest_nationality,
        currency: currency
      }
      body[:guestId] = guest_id if guest_id

      post('hotels/rates', body)
    end

    # Search for minimum rates for hotels
    #
    # Returns only the minimum rate per hotel for quick comparisons.
    #
    # @param hotel_ids [Array<String>] List of hotel IDs to search
    # @param checkin [String] Check-in date (YYYY-MM-DD)
    # @param checkout [String] Check-out date (YYYY-MM-DD)
    # @param occupancies [Array<Hash>] Room occupancies, each with :rooms, :adults, :children (ages array)
    # @param guest_nationality [String] Guest nationality (ISO-2)
    # @param currency [String] Currency code
    # @return [Hash] Minimum rates data
    #
    # @example
    #   client.min_rates(
    #     hotel_ids: ['lp1234'],
    #     checkin: '2025-03-01',
    #     checkout: '2025-03-03',
    #     occupancies: [{ rooms: 1, adults: 2 }],
    #     guest_nationality: 'US',
    #     currency: 'USD'
    #   )
    def min_rates(hotel_ids:, checkin:, checkout:, occupancies:, guest_nationality:, currency:)
      body = {
        hotelIds: hotel_ids,
        checkin: checkin,
        checkout: checkout,
        occupancies: occupancies,
        guestNationality: guest_nationality,
        currency: currency
      }

      post('hotels/min-rates', body)
    end
  end
end
