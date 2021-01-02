require 'net/http'

module Makuri::BrowserBuilder
  class NetHttp < Base
    def visit(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      headers = { 'User-Agent': user_agent }

      request = send("#{request_method}_request", uri.request_uri, headers)
      http.request(request).body
    end

    private

    def get_request(request_uri, headers)
      Net::HTTP::Get.new(request_uri, headers)
    end

    def post_request(request_uri, headers)
      request = Net::HTTP::Post.new request_uri, headers
      request.body = request_body
      request
    end
  end
end
