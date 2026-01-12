# frozen_string_literal: true

module Liteapi
  module Guests
    # Get loyalty program status
    #
    # @example
    #   client.loyalty
    def loyalty
      get('guests/loyalty')
    end

    # Enable loyalty program
    #
    # @example
    #   client.enable_loyalty(status: 'enabled', cashback_rate: 0.03)
    def enable_loyalty(**params)
      post('guests/loyalty', prepare_body_params(params))
    end

    # Update loyalty program
    #
    # @example
    #   client.update_loyalty(status: 'enabled', cashback_rate: 0.05)
    def update_loyalty(**params)
      put('guests/loyalty', prepare_body_params(params))
    end

    # Get guest details
    #
    # @example
    #   client.guest(123)
    def guest(guest_id)
      get("guests/#{guest_id}")
    end

    # Get guest bookings
    #
    # @example
    #   client.guest_bookings(123)
    def guest_bookings(guest_id)
      get("guests/#{guest_id}/bookings")
    end
  end
end
