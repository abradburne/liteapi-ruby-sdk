# frozen_string_literal: true

module Liteapi
  module Analytics
    # Retrieve weekly analytics
    #
    # @example
    #   client.weekly_analytics(from: '2025-01-01', to: '2025-01-07')
    def weekly_analytics(**params)
      dashboard_post('analytics/weekly', prepare_body_params(params))
    end

    # Retrieve detailed analytics report
    #
    # @example
    #   client.analytics_report(from: '2025-01-01', to: '2025-01-31')
    def analytics_report(**params)
      dashboard_post('analytics/report', prepare_body_params(params))
    end

    # Retrieve market analytics
    #
    # @example
    #   client.market_analytics(from: '2025-01-01', to: '2025-01-31')
    def market_analytics(**params)
      dashboard_post('analytics/market', prepare_body_params(params))
    end

    # Retrieve most booked hotels
    #
    # @example
    #   client.most_booked_hotels(from: '2025-01-01', to: '2025-01-31')
    def most_booked_hotels(**params)
      dashboard_post('analytics/top-hotels', prepare_body_params(params))
    end
  end
end
