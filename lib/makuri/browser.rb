module Makuri
  class Browser
    attr_accessor :url, :engine, :headless, :user_agent, :request_method, :request_body

    def initialize(options = {})
      @engine         = options.fetch(:engine, :net_http)
      @headless       = options.fetch(:headless, true)
      @user_agent     = options.fetch(
        :user_agent,
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36'
      )

      # Defaults
      @request_method = :get
      @request_body   = {}
    end

    def browser
      @browser ||= create_browser
    end

    # Allow for NetHttp get request
    def request(url, options = {})
      @url = url
      validate_url

      return follow if engine_chrome?

      @request_method = options.fetch(:method, request_method)
      @request_body   = options.fetch(:body, request_body)
      browser.visit(@url)
    end

    # Only allow for capybara get request
    def follow
      browser.visit(@url)
      browser
    end

    private

    def create_browser
      browser_engine = engine_chrome? ? 'Chrome' : 'NetHttp'
      builder        = Object.const_get "Makuri::BrowserBuilder::#{browser_engine}"
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

    def validate_url
      uri = URI.parse(@url)
      raise 'Invalid URL supplied' unless uri.is_a?(URI::HTTP) && !uri.host.nil?
    end

    def engine_chrome?
      engine == :chrome
    end
  end
end
