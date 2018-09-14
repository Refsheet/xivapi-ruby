require 'xivapi/version'

require 'xivapi/exceptions'
require 'xivapi/http'
require 'xivapi/page'
require 'xivapi/paginator'
require 'xivapi/request'

require 'rest-client'
require 'json'
require 'ostruct'

module XIVAPI
  LANGUAGE_OPTIONS = %w(en ja de fr cn kr).freeze
  TAGS_FORMAT = /^[a-z0-9\-_]+$/i.freeze

  class Client
    include XIVAPI::Request

    attr_accessor :api_key

    # Initializes a new client for querying XIVAPI
    # @param api_key [String] API key provided by XIVAPI
    # @param language [String] Requested response langauge
    # @param poll_rate [Integer] Frequency at which to poll when waiting for data to cache
    # @param tags [String, Array<String>] Optional string tag(s) for tracking requests
    def initialize(api_key: nil, language: 'en', poll_rate: 30, tags: nil)
      @api_key = api_key

      self.language = language
      self.poll_rate = poll_rate
      self.tags = tags if tags
    end

    def language
      @language
    end

    def language=(language)
      raise ArgumentError, 'Unsupported language' unless LANGUAGE_OPTIONS.include?(language.downcase)
      @language = language.downcase
    end

    def poll_rate
      @poll_rate
    end

    def poll_rate=(rate)
      raise ArgumentError, 'Poll rate must be a positive integer' unless rate.is_a?(Integer) && rate > 0
      @poll_rate = rate
    end

    def tags
      @tags
    end

    def tags=(tags)
      raise ArgumentError, 'Invalid tag format' unless [*tags].each { |tag| tag.match?(TAGS_FORMAT) }
      @tags = [*tags].join(',')
    end

    def default_params
      { key: @api_key, language: @language, tags: @tags }
    end
  end
end
