# frozen_string_literal: true

module Liteapi
  class Error < StandardError; end

  class APIError < Error
    attr_reader :status, :code, :response

    def initialize(message = nil, status: nil, code: nil, response: nil)
      @status = status
      @code = code
      @response = response
      super(message)
    end
  end

  class ClientError < APIError; end
  class ServerError < APIError; end

  class AuthenticationError < ClientError; end
  class NotFoundError < ClientError; end
  class RateLimitError < ClientError; end
  class ValidationError < ClientError; end
end
