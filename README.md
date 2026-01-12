# LiteAPI Ruby SDK

Ruby SDK for [LiteAPI](https://liteapi.travel) travel services.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Static Data](#static-data)
  - [List of Countries](#list-of-countries)
  - [List of Cities](#list-of-cities)
  - [List of Hotels](#list-of-hotels)
  - [Hotel Details](#hotel-details)
  - [Hotel Reviews](#hotel-reviews)
  - [Search Places](#search-places)
  - [List of Currencies](#list-of-currencies)
  - [IATA Codes](#iata-codes)
  - [Hotel Facilities](#hotel-facilities)
  - [Hotel Types](#hotel-types)
  - [Hotel Chains](#hotel-chains)
- [Booking Flow](#booking-flow)
  - [Search Rates](#search-rates)
    - [Full Rates](#full-rates)
    - [Minimum Rates](#minimum-rates)
  - [Book](#book)
    - [Prebook](#prebook)
    - [Book](#book-1)
  - [Booking Management](#booking-management)
    - [Booking List](#booking-list)
    - [Booking Details](#booking-details)
    - [Cancel Booking](#cancel-booking)
- [Guests & Loyalty](#guests--loyalty)
  - [Loyalty Program](#loyalty-program)
  - [Enable Loyalty](#enable-loyalty)
  - [Update Loyalty](#update-loyalty)
  - [Guest Details](#guest-details)
  - [Guest Bookings](#guest-bookings)
- [Vouchers](#vouchers)
  - [List Vouchers](#list-vouchers)
  - [Voucher Details](#voucher-details)
  - [Create Voucher](#create-voucher)
  - [Update Voucher](#update-voucher)
  - [Update Voucher Status](#update-voucher-status)
- [Analytics](#analytics)
  - [Weekly Analytics](#weekly-analytics)
  - [Analytics Report](#analytics-report)
  - [Market Analytics](#market-analytics)
  - [Most Booked Hotels](#most-booked-hotels)
- [Error Handling](#error-handling)

## Installation

Add to your Gemfile:

```ruby
gem 'liteapi'
```

Then run:

```sh
bundle install
```

## Configuration

```ruby
require 'liteapi'

# Global configuration
Liteapi.configure do |config|
  config.api_key = ENV['LITEAPI_API_KEY']
end

client = Liteapi::Client.new

# Or pass API key directly
client = Liteapi::Client.new(api_key: 'your_api_key')
```

### Configuration Options

| Option | Default | Description |
|--------|---------|-------------|
| `api_key` | `ENV['LITEAPI_API_KEY']` | Your LiteAPI key |
| `base_url` | `https://api.liteapi.travel/v3.0` | API base URL |
| `book_base_url` | `https://book.liteapi.travel/v3.0` | Booking API base URL |
| `dashboard_base_url` | `https://da.liteapi.travel` | Analytics API base URL |
| `timeout` | `30` | Request timeout in seconds |
| `open_timeout` | `10` | Connection timeout in seconds |
| `max_retries` | `3` | Retries on 429/5xx errors |

### API Documentation

For the full list of available parameters for each endpoint, see the official API documentation at **[docs.liteapi.travel](https://docs.liteapi.travel)**.

This SDK uses Ruby-style `snake_case` parameter names which are automatically converted to the API's `camelCase` format. For example, `country_code` becomes `countryCode`.

---

# Static Data

## List of Countries

Returns the list of countries available along with their ISO-2 codes.

```ruby
result = client.countries
```

**Parameters:** None

**Returns:** Array of country objects

| Field | Type | Description |
|-------|------|-------------|
| `code` | String | Country code in ISO-2 format |
| `name` | String | Name of the country |

---

## List of Cities

Returns a list of city names from a specific country.

```ruby
result = client.cities(country_code: 'IT')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `country_code` | String | Country code in ISO-2 format (e.g., 'US', 'IT') | Yes |

**Returns:** Array of city objects

| Field | Type | Description |
|-------|------|-------------|
| `city` | String | Name of the city |

---

## List of Hotels

Returns a list of hotels based on search criteria.

```ruby
result = client.hotels(country_code: 'IT', city_name: 'Rome')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `country_code` | String | Country code in ISO-2 format | Yes |
| `city_name` | String | City name to filter by | No |
| `latitude` | Float | Latitude for geo search | No |
| `longitude` | Float | Longitude for geo search | No |
| `radius` | Integer | Search radius in km | No |
| `language` | String | Language code (default: 'en') | No |

**Returns:** Array of hotel objects

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Unique hotel identifier |
| `name` | String | Hotel name |
| `hotelDescription` | String | Hotel description |
| `country` | String | Country code |
| `city` | String | City name |
| `latitude` | Float | Latitude coordinate |
| `longitude` | Float | Longitude coordinate |
| `address` | String | Hotel address |
| `zip` | String | Postal code |
| `stars` | Integer | Star rating |
| `main_photo` | String | URL of main photo |

---

## Hotel Details

Returns all static content details for a specific hotel.

```ruby
result = client.hotel('lp1897')
result = client.hotel('lp1897', language: 'fr')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `hotel_id` | String | Unique hotel identifier | Yes |
| `language` | String | Language code for response | No |

**Returns:** Hotel object with full details

| Field | Type | Description |
|-------|------|-------------|
| `id` | String | Hotel identifier |
| `name` | String | Hotel name |
| `hotelDescription` | String | Full description |
| `checkinCheckoutTimes` | Hash | Check-in/out times |
| `hotelImages` | Array | Array of image objects |
| `currency` | String | Currency code |
| `country` | String | Country code |
| `city` | String | City name |
| `starRating` | Integer | Star rating |
| `location` | Hash | Latitude/longitude |
| `address` | String | Full address |
| `hotelFacilities` | Array | List of facilities |

---

## Hotel Reviews

Returns reviews for a specific hotel with optional sentiment analysis.

```ruby
result = client.hotel_reviews(hotel_id: 'lp1897', limit: 100, sentiment: true)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `hotel_id` | String | Unique hotel identifier | Yes |
| `limit` | Integer | Max reviews to return (max 1000) | No |
| `sentiment` | Boolean | Include sentiment analysis | No |

**Returns:** Array of review objects

| Field | Type | Description |
|-------|------|-------------|
| `rating` | Integer | Review rating |
| `text` | String | Review text |
| `sentimentAnalysis` | Hash | Sentiment data (if requested) |

---

## Search Places

Search for places and areas by query text.

```ruby
result = client.places(query: 'Manhattan')
result = client.places(query: 'Rome', type: 'hotel', language: 'it')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `query` | String | Search query (e.g., 'Manhattan') | Yes |
| `type` | String | Filter by type (e.g., 'hotel') | No |
| `language` | String | Language code (default: 'en') | No |

**Returns:** Array of place objects

---

## List of Currencies

Returns all available currency codes.

```ruby
result = client.currencies
```

**Parameters:** None

**Returns:** Array of currency objects

| Field | Type | Description |
|-------|------|-------------|
| `code` | String | Currency code |
| `currency` | String | Currency name |
| `countries` | Array | Countries using this currency |

---

## IATA Codes

Returns IATA codes for all available airports.

```ruby
result = client.iata_codes
```

**Parameters:** None

**Returns:** Array of IATA objects

| Field | Type | Description |
|-------|------|-------------|
| `code` | String | IATA code |
| `name` | String | Airport name |
| `latitude` | Float | Latitude |
| `longitude` | Float | Longitude |
| `countryCode` | String | Country code |

---

## Hotel Facilities

Returns the list of available hotel facilities.

```ruby
result = client.hotel_facilities
```

**Parameters:** None

**Returns:** Array of facility objects

---

## Hotel Types

Returns the list of available hotel types.

```ruby
result = client.hotel_types
```

**Parameters:** None

**Returns:** Array of hotel type objects

---

## Hotel Chains

Returns the list of available hotel chains.

```ruby
result = client.hotel_chains
```

**Parameters:** None

**Returns:** Array of hotel chain objects

---

# Booking Flow

The booking flow consists of: **Search** → **Prebook** → **Book** → **Manage**

## Search Rates

### Full Rates

Returns all available rooms with rates and cancellation policies.

```ruby
result = client.full_rates(
  hotel_ids: ['lp3803c', 'lp1f982', 'lp19b70'],
  checkin: '2025-03-15',
  checkout: '2025-03-16',
  occupancies: [
    { rooms: 1, adults: 2, children: [2, 3] }
  ],
  currency: 'USD',
  guest_nationality: 'US',
  guest_id: 'guest_123'  # optional, for loyalty pricing
)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `hotel_ids` | Array | List of hotel IDs to search | Yes |
| `checkin` | String | Check-in date (YYYY-MM-DD) | Yes |
| `checkout` | String | Check-out date (YYYY-MM-DD) | Yes |
| `occupancies` | Array | Room occupancies (see below) | Yes |
| `currency` | String | Currency code (e.g., 'USD') | Yes |
| `guest_nationality` | String | Guest nationality ISO-2 code | Yes |
| `guest_id` | String | Guest ID for loyalty pricing | No |

**Occupancy object:**

| Field | Type | Description |
|-------|------|-------------|
| `rooms` | Integer | Number of rooms |
| `adults` | Integer | Number of adults |
| `children` | Array | Ages of children |

**Returns:** Hash with hotel rates

| Field | Type | Description |
|-------|------|-------------|
| `offerId` | String | Offer ID for prebook |
| `roomTypeId` | String | Room type identifier |
| `supplier` | String | Supplier name |
| `rates` | Array | Rate details with pricing |

---

### Minimum Rates

Returns only minimum rates per hotel for quick comparison.

```ruby
result = client.min_rates(
  hotel_ids: ['lp3803c', 'lp1f982'],
  checkin: '2025-03-15',
  checkout: '2025-03-16',
  occupancies: [{ rooms: 1, adults: 2 }],
  currency: 'USD',
  guest_nationality: 'US'
)
```

**Parameters:** Same as `full_rates` (except `guest_id`)

**Returns:** Array of minimum rate objects

| Field | Type | Description |
|-------|------|-------------|
| `hotelId` | String | Hotel identifier |
| `minRate` | Float | Minimum rate |

---

## Book

### Prebook

Confirms room availability and pricing before booking.

```ruby
result = client.prebook(offer_id: 'offer_abc123')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `offer_id` | String | Offer ID from full_rates response | Yes |

**Returns:** Prebook confirmation

| Field | Type | Description |
|-------|------|-------------|
| `prebookId` | String | Prebook ID for booking |
| `hotelId` | String | Hotel identifier |
| `currency` | String | Currency code |
| `price` | Float | Total price |
| `priceDifferencePercent` | Float | Price change percentage |
| `cancellationChanged` | Boolean | If cancellation policy changed |
| `roomTypes` | Array | Room and rate details |

---

### Book

Completes the booking with guest and payment information.

```ruby
result = client.book(
  prebook_id: 'prebook_xyz789',
  guest: {
    first_name: 'John',
    last_name: 'Doe',
    email: 'john.doe@example.com'
  },
  payment: {
    holder_name: 'John Doe',
    card_number: '4111111111111111',
    expire_date: '12/25',
    cvc: '123'
  },
  client_reference: 'my-booking-123'  # optional
)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `prebook_id` | String | Prebook ID from prebook response | Yes |
| `guest` | Hash | Guest information (see below) | Yes |
| `payment` | Hash | Payment information (see below) | Yes |
| `client_reference` | String | Your reference for the booking | No |

**Guest object:**

| Field | Type | Description |
|-------|------|-------------|
| `first_name` | String | Guest first name |
| `last_name` | String | Guest last name |
| `email` | String | Guest email |

**Payment object:**

| Field | Type | Description |
|-------|------|-------------|
| `holder_name` | String | Cardholder name |
| `card_number` | String | Credit card number |
| `expire_date` | String | Expiry date (MM/YY) |
| `cvc` | String | CVC code |

**Returns:** Booking confirmation

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` | String | Unique booking ID |
| `clientReference` | String | Your reference |
| `status` | String | Booking status |
| `hotelConfirmationCode` | String | Hotel confirmation code |
| `checkin` | String | Check-in date |
| `checkout` | String | Check-out date |
| `hotel` | Hash | Hotel details |
| `bookedRooms` | Array | Booked room details |
| `guestInfo` | Hash | Guest information |
| `price` | Float | Total price |
| `currency` | String | Currency code |
| `cancellationPolicies` | Hash | Cancellation policy details |

---

## Booking Management

### Booking List

Returns bookings by client reference.

```ruby
result = client.bookings(client_reference: 'my-booking-123')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `client_reference` | String | Your booking reference | Yes |

**Returns:** Array of booking objects

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` | String | Booking ID |

---

### Booking Details

Returns details for a specific booking.

```ruby
result = client.booking('booking_abc123')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `booking_id` | String | Booking ID | Yes |

**Returns:** Full booking object (same as book response)

---

### Cancel Booking

Cancels an existing booking (subject to cancellation policy).

```ruby
result = client.cancel_booking('booking_abc123')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `booking_id` | String | Booking ID to cancel | Yes |

**Returns:** Cancellation result

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` | String | Booking ID |
| `status` | String | New status ('cancelled') |
| `cancellation_fee` | Float | Cancellation fee charged |
| `refund_amount` | Float | Amount refunded |
| `currency` | String | Currency code |

---

# Guests & Loyalty

## Loyalty Program

Returns current loyalty program settings.

```ruby
result = client.loyalty
```

**Parameters:** None

**Returns:** Loyalty program object

| Field | Type | Description |
|-------|------|-------------|
| `status` | String | Program status ('enabled' or 'disabled') |
| `cashbackRate` | Float | Cashback rate (e.g., 0.03 = 3%) |

---

## Enable Loyalty

Creates a new loyalty program.

```ruby
result = client.enable_loyalty(status: 'enabled', cashback_rate: 0.03)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `status` | String | Program status ('enabled' or 'disabled') | Yes |
| `cashback_rate` | Float | Cashback rate (e.g., 0.03 = 3%) | Yes |

**Returns:** Loyalty program object

---

## Update Loyalty

Updates existing loyalty program settings.

```ruby
result = client.update_loyalty(status: 'enabled', cashback_rate: 0.05)
```

**Parameters:** Same as `enable_loyalty`

**Returns:** Updated loyalty program object

---

## Guest Details

Retrieves detailed information about a guest.

```ruby
result = client.guest(123)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `guest_id` | String/Integer | Guest identifier | Yes |

**Returns:** Guest object

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Guest identifier |
| `firstName` | String | First name |
| `lastName` | String | Last name |
| `email` | String | Email address |
| `loyaltyPoints` | Integer | Accumulated points |

---

## Guest Bookings

Retrieves all bookings for a guest with loyalty information.

```ruby
result = client.guest_bookings(123)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `guest_id` | String/Integer | Guest identifier | Yes |

**Returns:** Array of booking objects with loyalty data

| Field | Type | Description |
|-------|------|-------------|
| `bookingId` | String | Booking identifier |
| `loyaltyPoints` | Integer | Points earned |
| `cashbackApplied` | Float | Cashback amount |

---

# Vouchers

## List Vouchers

Retrieves all available vouchers.

```ruby
result = client.vouchers
```

**Parameters:** None

**Returns:** Array of voucher objects

| Field | Type | Description |
|-------|------|-------------|
| `id` | Integer | Voucher identifier |
| `voucher_code` | String | Voucher code |
| `discount_type` | String | 'percentage' or 'fixed' |
| `discount_value` | Float | Discount amount |
| `status` | String | 'active' or 'inactive' |

---

## Voucher Details

Retrieves details for a specific voucher.

```ruby
result = client.voucher(42)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `voucher_id` | String/Integer | Voucher identifier | Yes |

**Returns:** Voucher object with full details

---

## Create Voucher

Creates a new voucher.

```ruby
result = client.create_voucher(
  voucher_code: 'SUMMER20',
  discount_type: 'percentage',
  discount_value: 20,
  minimum_spend: 100,
  maximum_discount_amount: 50,
  currency: 'USD',
  validity_start: '2025-06-01',
  validity_end: '2025-08-31',
  usages_limit: 100,
  status: 'active'
)
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `voucher_code` | String | Unique voucher code | Yes |
| `discount_type` | String | 'percentage' or 'fixed' | Yes |
| `discount_value` | Float | Discount value | Yes |
| `minimum_spend` | Float | Minimum spend to apply | Yes |
| `maximum_discount_amount` | Float | Maximum discount | Yes |
| `currency` | String | Currency code | Yes |
| `validity_start` | String | Start date (YYYY-MM-DD) | Yes |
| `validity_end` | String | End date (YYYY-MM-DD) | Yes |
| `usages_limit` | Integer | Maximum redemptions | Yes |
| `status` | String | 'active' or 'inactive' | Yes |

**Returns:** Creation confirmation

---

## Update Voucher

Updates an existing voucher.

```ruby
result = client.update_voucher(42,
  voucher_code: 'SUMMER25',
  discount_type: 'percentage',
  discount_value: 25,
  # ... all other parameters required
)
```

**Parameters:** `voucher_id` plus all parameters from `create_voucher`

**Returns:** Update confirmation

---

## Update Voucher Status

Activates or deactivates a voucher.

```ruby
result = client.update_voucher_status(42, status: 'inactive')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `voucher_id` | String/Integer | Voucher identifier | Yes |
| `status` | String | 'active' or 'inactive' | Yes |

**Returns:** Status update confirmation

---

# Analytics

## Weekly Analytics

Fetches weekly analytics data for a date range.

```ruby
result = client.weekly_analytics(from: '2025-01-01', to: '2025-01-07')
```

**Parameters:**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| `from` | String | Start date (YYYY-MM-DD) | Yes |
| `to` | String | End date (YYYY-MM-DD) | Yes |

**Returns:** Weekly analytics object

| Field | Type | Description |
|-------|------|-------------|
| `totalBookings` | Integer | Total bookings |
| `totalRevenue` | Float | Total revenue |

---

## Analytics Report

Fetches a detailed analytics report.

```ruby
result = client.analytics_report(from: '2025-01-01', to: '2025-01-31')
```

**Parameters:** Same as `weekly_analytics`

**Returns:** Detailed report object

| Field | Type | Description |
|-------|------|-------------|
| `totalRevenue` | Float | Total revenue |
| `salesRevenue` | Float | Sales revenue |

---

## Market Analytics

Fetches market-level analytics data.

```ruby
result = client.market_analytics(from: '2025-01-01', to: '2025-01-31')
```

**Parameters:** Same as `weekly_analytics`

**Returns:** Market analytics object

| Field | Type | Description |
|-------|------|-------------|
| `markets` | Array | Market breakdown by country |

---

## Most Booked Hotels

Fetches data on most booked hotels.

```ruby
result = client.most_booked_hotels(from: '2025-01-01', to: '2025-01-31')
```

**Parameters:** Same as `weekly_analytics`

**Returns:** Array of hotel objects

| Field | Type | Description |
|-------|------|-------------|
| `hotelId` | String | Hotel identifier |
| `bookings` | Integer | Number of bookings |

---

# Error Handling

The SDK raises specific exceptions for different error types:

```ruby
begin
  client.hotel('invalid_id')
rescue Liteapi::AuthenticationError => e
  # 401 - Invalid API key
  puts "Auth error: #{e.message}"
  puts "Status: #{e.status}"
rescue Liteapi::NotFoundError => e
  # 404 - Resource not found
  puts "Not found: #{e.message}"
rescue Liteapi::ValidationError => e
  # 422 - Invalid request parameters
  puts "Validation error: #{e.message}"
rescue Liteapi::RateLimitError => e
  # 429 - Too many requests
  puts "Rate limited: #{e.message}"
rescue Liteapi::ServerError => e
  # 5xx - Server error
  puts "Server error: #{e.message}"
rescue Liteapi::APIError => e
  # Other API errors
  puts "API error (#{e.status}): #{e.message}"
  puts "Response: #{e.response}"
end
```

All API errors include:
- `message` - Error description
- `status` - HTTP status code
- `code` - API error code
- `response` - Full error response

---

## Development

```sh
bundle install
bundle exec rake test
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
