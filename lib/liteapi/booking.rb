# frozen_string_literal: true

module Liteapi
  module Booking
    # Pre-book a rate to confirm availability and pricing
    #
    # @example
    #   client.prebook(offer_id: 'offer_abc123')
    def prebook(**params)
      book_post('rates/prebook', prepare_body_params(params))
    end

    # Complete a booking
    #
    # @example
    #   client.book(
    #     prebook_id: 'prebook_123',
    #     guest_info: {
    #       guest_first_name: 'John',
    #       guest_last_name: 'Doe',
    #       guest_email: 'john@example.com'
    #     },
    #     payment_method: {
    #       holder_name: 'John Doe',
    #       card_number: '4111111111111111',
    #       expire_date: '12/25',
    #       cvc: '123'
    #     }
    #   )
    def book(**params)
      book_post('rates/book', prepare_body_params(params))
    end

    # List bookings by client reference
    #
    # @example
    #   client.bookings(client_reference: 'my-booking-123')
    def bookings(**params)
      book_get('bookings', prepare_query_params(params))
    end

    # Retrieve a specific booking
    #
    # @example
    #   client.booking('booking_abc123')
    def booking(booking_id)
      book_get("bookings/#{booking_id}")
    end

    # Cancel a booking
    #
    # @example
    #   client.cancel_booking('booking_abc123')
    def cancel_booking(booking_id)
      book_put("bookings/#{booking_id}")
    end
  end
end
