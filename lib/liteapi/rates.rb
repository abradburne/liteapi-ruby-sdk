# frozen_string_literal: true

module Liteapi
  module Rates
    # Search for full rates and availability for hotels
    #
    # Returns all available rooms with rates, cancellation policies for a list of hotel IDs.
    #
    # @example
    #   client.full_rates(
    #     hotel_ids: ['lp1234', 'lp5678'],
    #     checkin: '2025-03-01',
    #     checkout: '2025-03-03',
    #     occupancies: [{ rooms: 1, adults: 2, children: [5, 10] }],
    #     currency: 'USD',
    #     guest_nationality: 'US'
    #   )
    def full_rates(**params)
      post('hotels/rates', prepare_body_params(params))
    end

    # Search for minimum rates for hotels
    #
    # Returns only the minimum rate per hotel for quick comparisons.
    #
    # @example
    #   client.min_rates(
    #     hotel_ids: ['lp1234'],
    #     checkin: '2025-03-01',
    #     checkout: '2025-03-03',
    #     occupancies: [{ rooms: 1, adults: 2 }],
    #     currency: 'USD',
    #     guest_nationality: 'US'
    #   )
    def min_rates(**params)
      post('hotels/min-rates', prepare_body_params(params))
    end
  end
end
