# frozen_string_literal: true

module Liteapi
  module Vouchers
    # List all vouchers
    #
    # @example
    #   client.vouchers
    def vouchers
      get('vouchers')
    end

    # Get voucher details
    #
    # @example
    #   client.voucher(42)
    def voucher(voucher_id)
      get("vouchers/#{voucher_id}")
    end

    # Create a voucher
    #
    # @example
    #   client.create_voucher(
    #     voucher_code: 'SUMMER20',
    #     discount_type: 'percentage',
    #     discount_value: 20,
    #     minimum_spend: 100,
    #     maximum_discount_amount: 50,
    #     currency: 'USD',
    #     validity_start: '2025-06-01',
    #     validity_end: '2025-08-31',
    #     usages_limit: 100,
    #     status: 'active'
    #   )
    def create_voucher(**params)
      post('vouchers', prepare_body_params(params))
    end

    # Update a voucher
    #
    # @example
    #   client.update_voucher(42, voucher_code: 'SUMMER25', discount_value: 25, ...)
    def update_voucher(voucher_id, **params)
      put("vouchers/#{voucher_id}", prepare_body_params(params))
    end

    # Update voucher status
    #
    # @example
    #   client.update_voucher_status(42, status: 'inactive')
    def update_voucher_status(voucher_id, **params)
      put("vouchers/#{voucher_id}/status", prepare_body_params(params))
    end
  end
end
