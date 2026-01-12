# frozen_string_literal: true

require_relative 'liteapi/version'
require_relative 'liteapi/configuration'
require_relative 'liteapi/errors'
require_relative 'liteapi/connection'
require_relative 'liteapi/static_data'
require_relative 'liteapi/rates'
require_relative 'liteapi/booking'
require_relative 'liteapi/guests'
require_relative 'liteapi/vouchers'
require_relative 'liteapi/analytics'
require_relative 'liteapi/client'

module Liteapi
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
