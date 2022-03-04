class TokenAuthenticator
  class ServiceUnavailableError < StandardError; end
  class InvalidResponseError < StandardError; end

  URL = ENV.fetch('TOKENS_URL').freeze
  CACHE_TTL = ENV.fetch('TOKENS_CACHE_TTL', 300).to_i
  CACHE_KEY = 'ipfs-api-tokens'.freeze

  attr_reader :token

  def initialize(token)
    @token = token
  end

  # Returns storage limit of the token if it's valid, or nil.
  def call
    tokens = Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_TTL) { get_tokens }
    tokens[token]
  end

  private

  def get_tokens
    response = HTTP.get(URL)
    raise ServiceUnavailableError unless response.status.success?

    tokens = JSON.parse(response.body.to_s).each_with_object({}) do |data, h|
      h[data.fetch('key')] = data.fetch('storage').to_i.gigabytes
    end

    tokens
  rescue JSON::ParserError, KeyError
    raise InvalidResponseError
  end
end
