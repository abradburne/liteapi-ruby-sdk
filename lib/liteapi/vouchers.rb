# frozen_string_literal: true

module Liteapi
  module Vouchers
    # List all vouchers
    #
    # Retrieves all available vouchers including codes, discounts, and validity.
    #
    # @return [Array] List of voucher objects
    def vouchers
      get('vouchers')
    end

    # Get voucher details
    #
    # Retrieves details for a specific voucher.
    #
    # @param voucher_id [String, Integer] Voucher identifier
    # @return [Hash] Voucher details
    def voucher(voucher_id)
      get("vouchers/#{voucher_id}")
    end

    # Create a voucher
    #
    # Creates a new voucher with specified settings.
    #
    # @param voucher_code [String] Unique voucher code
    # @param discount_type [String] Type of discount ('percentage' or 'fixed')
    # @param discount_value [Float] Discount value
    # @param minimum_spend [Float] Minimum spend to apply voucher
    # @param maximum_discount_amount [Float] Maximum discount amount
    # @param currency [String] Currency code
    # @param validity_start [String] Start date (YYYY-MM-DD)
    # @param validity_end [String] End date (YYYY-MM-DD)
    # @param usages_limit [Integer] Maximum redemptions
    # @param status [String] Voucher status ('active' or 'inactive')
    # @return [Hash] Created voucher confirmation
    def create_voucher(voucher_code:, discount_type:, discount_value:, minimum_spend:,
                       maximum_discount_amount:, currency:, validity_start:, validity_end:,
                       usages_limit:, status:)
      post('vouchers', {
        voucher_code: voucher_code,
        discount_type: discount_type,
        discount_value: discount_value,
        minimum_spend: minimum_spend,
        maximum_discount_amount: maximum_discount_amount,
        currency: currency,
        validity_start: validity_start,
        validity_end: validity_end,
        usages_limit: usages_limit,
        status: status
      })
    end

    # Update a voucher
    #
    # Updates an existing voucher's settings.
    #
    # @param voucher_id [String, Integer] Voucher identifier
    # @param voucher_code [String] Unique voucher code
    # @param discount_type [String] Type of discount
    # @param discount_value [Float] Discount value
    # @param minimum_spend [Float] Minimum spend
    # @param maximum_discount_amount [Float] Maximum discount
    # @param currency [String] Currency code
    # @param validity_start [String] Start date (YYYY-MM-DD)
    # @param validity_end [String] End date (YYYY-MM-DD)
    # @param usages_limit [Integer] Maximum redemptions
    # @param status [String] Voucher status
    # @return [Hash] Update confirmation
    def update_voucher(voucher_id, voucher_code:, discount_type:, discount_value:, minimum_spend:,
                       maximum_discount_amount:, currency:, validity_start:, validity_end:,
                       usages_limit:, status:)
      put("vouchers/#{voucher_id}", {
        voucher_code: voucher_code,
        discount_type: discount_type,
        discount_value: discount_value,
        minimum_spend: minimum_spend,
        maximum_discount_amount: maximum_discount_amount,
        currency: currency,
        validity_start: validity_start,
        validity_end: validity_end,
        usages_limit: usages_limit,
        status: status
      })
    end

    # Update voucher status
    #
    # Activates or deactivates a voucher.
    #
    # @param voucher_id [String, Integer] Voucher identifier
    # @param status [String] New status ('active' or 'inactive')
    # @return [Hash] Update confirmation
    def update_voucher_status(voucher_id, status:)
      put("vouchers/#{voucher_id}/status", { status: status })
    end
  end
end
