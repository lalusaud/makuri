module Makuri
  class Browser
    attr_accessor :url, :js, :headless, :user_agent, :request_method, :request_body

    def initialize(options = {})
      @js             = options.fetch(:js, false)
      @headless       = options.fetch(:headless, true)
      @user_agent     = options.fetch(
        :user_agent,
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36'
      )
    end

    def browser
      @browser ||= create_browser
    end

    # Only allow for capybara get request
    def follow(url)
      validate_url(url)

      browser.visit(@url)
      browser
    end

    # Allow for NetHttp get request
    def request(url, options = {})
      validate_url(url)

      @request_method = options.fetch(:method, :get)
      @request_body   = options.fetch(:body, {})

      raise 'Invalid request type for js=true. Use #follow in place of #get' if js

      # return request body
      browser.visit(@url).body
    end

    private

    def create_browser
      engine = js ? 'Chrome' : 'NetHttp'
      builder = Object.const_get "Makuri::BrowserBuilder::#{engine}"
      builder.new(browser_params).build
    end

    def browser_params
      {
        user_agent: user_agent,
        headless: headless,
        request_method: request_method,
        request_body: request_body
      }
    end

    def validate_url(url = '')
      @url = url
      uri = URI.parse(url)
      raise 'Invalid URL supplied' unless uri.is_a?(URI::HTTP) && !uri.host.nil?
    end
  end
end
