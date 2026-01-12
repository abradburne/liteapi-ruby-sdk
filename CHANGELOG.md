# Changelog

## [0.2.0] - 2025-01-12

### Changed

- **Dynamic parameters**: All methods now accept arbitrary keyword arguments that are automatically converted from Ruby `snake_case` to API `camelCase`. This allows using new API parameters without SDK updates.
- Nested hashes and arrays are recursively transformed for POST/PUT request bodies.
- Array parameters in GET requests are joined with commas for query strings.

### Fixed

- Properly handle nested structures like `occupancies` in rates requests.

## [0.1.0] - 2025-01-12

### Added

- Initial release

**Static Data:**
- `countries` - List all countries
- `cities(country_code:)` - List cities by country
- `places(query:, type:, language:)` - Search places
- `currencies` - List currencies
- `iata_codes` - List airport IATA codes
- `hotel_facilities` - List hotel facilities
- `hotel_types` - List hotel types
- `hotel_chains` - List hotel chains
- `hotels(country_code:, ...)` - Search hotels
- `hotel(hotel_id, language:)` - Get hotel details
- `hotel_reviews(hotel_id:, limit:, sentiment:)` - Get hotel reviews

**Rates:**
- `full_rates(hotel_ids:, checkin:, checkout:, occupancies:, ...)` - Full rates and availability
- `min_rates(hotel_ids:, checkin:, checkout:, occupancies:, ...)` - Minimum rates

**Booking:**
- `prebook(offer_id:)` - Prebook to confirm availability
- `book(prebook_id:, guest:, payment:, client_reference:)` - Complete booking
- `bookings(client_reference:)` - List bookings by reference
- `booking(booking_id)` - Get booking details
- `cancel_booking(booking_id)` - Cancel a booking

**Guests & Loyalty:**
- `loyalty` - Get loyalty program status
- `enable_loyalty(status:, cashback_rate:)` - Enable loyalty program
- `update_loyalty(status:, cashback_rate:)` - Update loyalty settings
- `guest(guest_id)` - Get guest details
- `guest_bookings(guest_id)` - Get guest's bookings

**Vouchers:**
- `vouchers` - List all vouchers
- `voucher(voucher_id)` - Get voucher details
- `create_voucher(...)` - Create a voucher
- `update_voucher(voucher_id, ...)` - Update a voucher
- `update_voucher_status(voucher_id, status:)` - Update voucher status

**Analytics:**
- `weekly_analytics(from:, to:)` - Weekly analytics data
- `analytics_report(from:, to:)` - Detailed analytics report
- `market_analytics(from:, to:)` - Market-level analytics
- `most_booked_hotels(from:, to:)` - Most booked hotels
