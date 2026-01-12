# frozen_string_literal: true

require_relative 'lib/liteapi/version'

Gem::Specification.new do |spec|
  spec.name = 'liteapi'
  spec.version = Liteapi::VERSION
  spec.authors = ['Alan Bradburne']
  spec.email = ['abradburne@gmail.com']

  spec.summary = 'Ruby SDK for LiteAPI travel services'
  spec.description = 'A Ruby-native SDK for the LiteAPI travel platform, providing access to hotel search, booking, and static data endpoints.'
  spec.homepage = 'https://github.com/abradburne/liteapi-ruby-sdk'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob('{lib}/**/*') + %w[LICENSE.txt README.md CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'faraday-retry', '~> 2.0'
end
