require 'net/http'

module Makuri
  class Browser
    attr_accessor :url, :headers

    def initialize(options = {})
      @url = options.fetch(:url, '')
    end

    def run
      raise 'Invalid URL supplied' if url.to_s.empty?

      Net::HTTP.get URI(url)
    end
  end
end
