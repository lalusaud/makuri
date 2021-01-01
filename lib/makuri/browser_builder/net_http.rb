require 'net/http'

module Makuri::BrowserBuilder
  class NetHttp
    attr_accessor :user_agent

    def initialize(options)
      @user_agent = options.fetch(:user_agent, 'Makuri')
    end

    def visit(url)
      uri = URI(url)
      request = Net::HTTP::Get.new uri
      request['User-Agent'] = user_agent

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: (uri.scheme == 'https')) do |http|
        http.request(request)
      end.body
    end
  end
end
