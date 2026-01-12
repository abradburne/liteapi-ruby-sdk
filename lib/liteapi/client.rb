# frozen_string_literal: true

module Liteapi
  class Client
    include StaticData
    include Rates
    include Booking
    include Guests
    include Vouchers
    include Analytics

    attr_reader :api_key, :base_url, :book_base_url, :dashboard_base_url,
                :timeout, :open_timeout, :max_retries

    def initialize(api_key: nil, base_url: nil, book_base_url: nil, dashboard_base_url: nil,
                   timeout: nil, open_timeout: nil, max_retries: nil)
      config = Liteapi.configuration

      @api_key = api_key || config.api_key
      @base_url = base_url || config.base_url
      @book_base_url = book_base_url || config.book_base_url
      @dashboard_base_url = dashboard_base_url || config.dashboard_base_url
      @timeout = timeout || config.timeout
      @open_timeout = open_timeout || config.open_timeout
      @max_retries = max_retries || config.max_retries

      validate_api_key!
    end

    private

    def validate_api_key!
      return if @api_key && !@api_key.empty?

      raise Liteapi::Error, 'API key is required. Set via Liteapi.configure or pass api_key: to Client.new'
    end

    def connection
      @connection ||= Connection.new(
        api_key: @api_key,
        base_url: @base_url,
        timeout: @timeout,
        open_timeout: @open_timeout,
        max_retries: @max_retries
      )
    end

    def book_connection
      @book_connection ||= Connection.new(
        api_key: @api_key,
        base_url: @book_base_url,
        timeout: @timeout,
        open_timeout: @open_timeout,
        max_retries: @max_retries
      )
    end

    def dashboard_connection
      @dashboard_connection ||= Connection.new(
        api_key: @api_key,
        base_url: @dashboard_base_url,
        timeout: @timeout,
        open_timeout: @open_timeout,
        max_retries: @max_retries
      )
    end

    def get(path, params = {})
      connection.get(path, params)
    end

    def post(path, body = {})
      connection.post(path, body)
    end

    def put(path, body = {})
      connection.put(path, body)
    end

    def book_get(path, params = {})
      book_connection.get(path, params)
    end

    def book_post(path, body = {})
      book_connection.post(path, body)
    end

    def book_put(path, body = {})
      book_connection.put(path, body)
    end

    def dashboard_get(path, params = {})
      dashboard_connection.get(path, params)
    end

    def dashboard_post(path, body = {})
      dashboard_connection.post(path, body)
    end
  end
end
