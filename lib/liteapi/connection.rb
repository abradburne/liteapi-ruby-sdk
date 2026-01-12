# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

module Liteapi
  class Connection
    RETRY_STATUSES = [429, 500, 502, 503, 504].freeze

    def initialize(api_key:, base_url:, timeout:, open_timeout:, max_retries:)
      @api_key = api_key
      @base_url = base_url
      @timeout = timeout
      @open_timeout = open_timeout
      @max_retries = max_retries
    end

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, body = {})
      request(:post, path, body)
    end

    def put(path, body = {})
      request(:put, path, body)
    end

    private

    def request(method, path, payload)
      response = connection.public_send(method, path) do |req|
        case method
        when :get
          req.params = payload if payload.any?
        when :post, :put
          req.body = payload
        end
      end

      handle_response(response)
    rescue Faraday::TimeoutError
      raise Liteapi::Error, 'Request timed out'
    rescue Faraday::ConnectionFailed
      raise Liteapi::Error, 'Connection failed'
    end

    def handle_response(response)
      body = response.body || {}

      case response.status
      when 200..299
        body['data']
      when 401
        raise AuthenticationError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      when 404
        raise NotFoundError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      when 422
        raise ValidationError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      when 429
        raise RateLimitError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      when 400..499
        raise ClientError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      when 500..599
        raise ServerError.new(
          error_message(body),
          status: response.status,
          code: body.dig('error', 'code'),
          response: body
        )
      else
        raise APIError.new(
          "Unexpected response status: #{response.status}",
          status: response.status,
          response: body
        )
      end
    end

    def error_message(body)
      body.dig('error', 'message') || body['message'] || 'Unknown error'
    end

    def connection
      @connection ||= Faraday.new(url: @base_url) do |f|
        f.request :json
        f.response :json
        f.request :retry, retry_options
        f.options.timeout = @timeout
        f.options.open_timeout = @open_timeout
        f.headers['X-API-Key'] = @api_key
        f.headers['Accept'] = 'application/json'
        f.adapter Faraday.default_adapter
      end
    end

    def retry_options
      {
        max: @max_retries,
        interval: 0.5,
        interval_randomness: 0.5,
        backoff_factor: 2,
        retry_statuses: RETRY_STATUSES,
        retry_block: ->(_env, _options, retries, exception) {
          # Could add logging here if needed
        }
      }
    end
  end
end
