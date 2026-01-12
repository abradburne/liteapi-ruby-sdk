# frozen_string_literal: true

module Liteapi
  module Guests
    # Get loyalty program status
    #
    # Returns current loyalty program settings including status and cashback rates.
    #
    # @return [Hash] Loyalty program details
    def loyalty
      get('guests/loyalty')
    end

    # Enable loyalty program
    #
    # Creates a new loyalty program with specified settings.
    #
    # @param status [String] Program status ('enabled' or 'disabled')
    # @param cashback_rate [Float] Cashback rate (e.g., 0.03 = 3%)
    # @return [Hash] Loyalty program details
    def enable_loyalty(status:, cashback_rate:)
      post('guests/loyalty', {
        status: status,
        cashbackRate: cashback_rate
      })
    end

    # Update loyalty program
    #
    # Updates existing loyalty program settings.
    #
    # @param status [String] Program status ('enabled' or 'disabled')
    # @param cashback_rate [Float] Cashback rate (e.g., 0.03 = 3%)
    # @return [Hash] Updated loyalty program details
    def update_loyalty(status:, cashback_rate:)
      put('guests/loyalty', {
        status: status,
        cashbackRate: cashback_rate
      })
    end

    # Get guest details
    #
    # Retrieves detailed information about a guest including personal data,
    # loyalty points, and booking history.
    #
    # @param guest_id [String, Integer] Guest identifier
    # @return [Hash] Guest details
    def guest(guest_id)
      get("guests/#{guest_id}")
    end

    # Get guest bookings
    #
    # Retrieves all bookings for a specific guest with loyalty points
    # and cashback information.
    #
    # @param guest_id [String, Integer] Guest identifier
    # @return [Array] List of guest bookings
    def guest_bookings(guest_id)
      get("guests/#{guest_id}/bookings")
    end
  end
end
