# frozen_string_literal: true

module Liteapi
  module Booking
    # Pre-book a rate to confirm availability and pricing
    #
    # Confirms if the room and rates are still available. Returns a prebook_id
    # needed for the final booking.
    #
    # @param offer_id [String] The offer/rate ID from full_rates
    # @return [Hash] Prebook confirmation with prebook_id
    def prebook(offer_id:)
      book_post('rates/prebook', { offerId: offer_id })
    end

    # Complete a booking
    #
    # Confirms the booking with guest and payment information.
    #
    # @param prebook_id [String] The prebook ID from prebook response
    # @param guest [Hash] Guest information (first_name, last_name, email)
    # @param payment [Hash] Payment information (card holder name, number, expiry, cvc)
    # @param client_reference [String, nil] Your reference for this booking
    # @return [Hash] Booking confirmation with booking_id
    def book(prebook_id:, guest:, payment:, client_reference: nil)
      body = {
        prebookId: prebook_id,
        guestInfo: {
          guestFirstName: guest[:first_name],
          guestLastName: guest[:last_name],
          guestEmail: guest[:email]
        },
        paymentMethod: {
          holderName: payment[:holder_name],
          paymentMethodId: payment[:payment_method_id] || 'creditCard',
          cardNumber: payment[:card_number],
          expireDate: payment[:expire_date],
          cvc: payment[:cvc]
        }
      }
      body[:clientReference] = client_reference if client_reference

      book_post('rates/book', body)
    end

    # List bookings by client reference
    #
    # @param client_reference [String] Your reference to search for
    # @return [Array] List of bookings
    def bookings(client_reference:)
      book_get('bookings', clientReference: client_reference)
    end

    # Retrieve a specific booking
    #
    # @param booking_id [String] The booking ID
    # @return [Hash] Booking details
    def booking(booking_id)
      book_get("bookings/#{booking_id}")
    end

    # Cancel a booking
    #
    # Cancellation success depends on the cancellation policy.
    # Non-refundable bookings or those past the cancellation date cannot be cancelled.
    #
    # @param booking_id [String] The booking ID to cancel
    # @return [Hash] Cancellation confirmation
    def cancel_booking(booking_id)
      book_put("bookings/#{booking_id}")
    end
  end
end
