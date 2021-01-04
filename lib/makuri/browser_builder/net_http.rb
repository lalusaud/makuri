require 'net/http'

module Makuri::BrowserBuilder
  class NetHttp < Base
    def visit(url)
      uri = URI(url)
      headers = { 'User-Agent': user_agent }

      request = send("#{request_method}_request", uri.request_uri, headers)

      Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https')) do |http|
        http.request(request)
      end.body
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
