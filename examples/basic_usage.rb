#!/usr/bin/env ruby
# frozen_string_literal: true

# Verification script for LiteAPI Ruby SDK
# Usage: LITEAPI_API_KEY=your_key ruby examples/verify.rb

require_relative '../lib/liteapi'

api_key = ENV['LITEAPI_API_KEY']
unless api_key
  puts 'Please set LITEAPI_API_KEY environment variable'
  exit 1
end

client = Liteapi::Client.new(api_key: api_key)

puts '=== LiteAPI Ruby SDK Verification ==='
puts

# Calculate dates for rate search (2 weeks from now)
checkin = (Date.today + 14).to_s
checkout = (Date.today + 16).to_s

# Test each endpoint
tests = [
  # Static Data
  ['countries', -> { client.countries }],
  ['currencies', -> { client.currencies }],
  ['iata_codes', -> { client.iata_codes }],
  ['hotel_facilities', -> { client.hotel_facilities }],
  ['hotel_types', -> { client.hotel_types }],
  ['hotel_chains', -> { client.hotel_chains }],
  ['cities(country_code: "SG")', -> { client.cities(country_code: 'SG') }],
  ['places(query: "Rome")', -> { client.places(query: 'Rome') }],

  # Rates
  ['min_rates (Singapore hotel)', lambda {
    client.min_rates(
      hotel_ids: ['lp24447'],
      checkin: checkin,
      checkout: checkout,
      occupancies: [{ rooms: 1, adults: 2 }],
      guest_nationality: 'US',
      currency: 'USD'
    )
  }]
]

tests.each do |name, test|
  print "Testing #{name}... "
  begin
    result = test.call
    count = result.is_a?(Array) ? result.size : 1
    puts "OK (#{count} items)"
  rescue Liteapi::APIError => e
    puts "FAILED: #{e.class} - #{e.message}"
  rescue StandardError => e
    puts "ERROR: #{e.class} - #{e.message}"
  end
end

puts
puts 'Done!'
