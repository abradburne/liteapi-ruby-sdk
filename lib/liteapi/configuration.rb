# frozen_string_literal: true

module Liteapi
  class Configuration
    attr_accessor :api_key, :base_url, :book_base_url, :dashboard_base_url,
                  :timeout, :open_timeout, :max_retries

    DEFAULT_BASE_URL = 'https://api.liteapi.travel/v3.0'
    DEFAULT_BOOK_BASE_URL = 'https://book.liteapi.travel/v3.0'
    DEFAULT_DASHBOARD_BASE_URL = 'https://da.liteapi.travel'
    DEFAULT_TIMEOUT = 30
    DEFAULT_OPEN_TIMEOUT = 10
    DEFAULT_MAX_RETRIES = 3

    def initialize
      @api_key = ENV.fetch('LITEAPI_API_KEY', nil)
      @base_url = DEFAULT_BASE_URL
      @book_base_url = DEFAULT_BOOK_BASE_URL
      @dashboard_base_url = DEFAULT_DASHBOARD_BASE_URL
      @timeout = DEFAULT_TIMEOUT
      @open_timeout = DEFAULT_OPEN_TIMEOUT
      @max_retries = DEFAULT_MAX_RETRIES
    end
  end
end
