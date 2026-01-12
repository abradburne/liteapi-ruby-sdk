# frozen_string_literal: true

module Liteapi
  module Analytics
    # Retrieve weekly analytics
    #
    # Fetches weekly analytics data for a date range.
    #
    # @param from [String] Start date (YYYY-MM-DD)
    # @param to [String] End date (YYYY-MM-DD)
    # @return [Hash] Weekly analytics data
    def weekly_analytics(from:, to:)
      dashboard_post('analytics/weekly', { from: from, to: to })
    end

    # Retrieve detailed analytics report
    #
    # Fetches a detailed analytics report including revenue and sales data.
    #
    # @param from [String] Start date (YYYY-MM-DD)
    # @param to [String] End date (YYYY-MM-DD)
    # @return [Hash] Detailed analytics report
    def analytics_report(from:, to:)
      dashboard_post('analytics/report', { from: from, to: to })
    end

    # Retrieve market analytics
    #
    # Fetches market-level analytics data.
    #
    # @param from [String] Start date (YYYY-MM-DD)
    # @param to [String] End date (YYYY-MM-DD)
    # @return [Hash] Market analytics data
    def market_analytics(from:, to:)
      dashboard_post('analytics/market', { from: from, to: to })
    end

    # Retrieve most booked hotels
    #
    # Fetches data on most booked hotels during a date range.
    #
    # @param from [String] Start date (YYYY-MM-DD)
    # @param to [String] End date (YYYY-MM-DD)
    # @return [Array] List of most booked hotels
    def most_booked_hotels(from:, to:)
      dashboard_post('analytics/top-hotels', { from: from, to: to })
    end
  end
end
