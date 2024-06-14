module Makuri
  class Browser
    attr_accessor :url, :engine, :headless, :user_agent, :request_method, :request_body

    def initialize(options = {})
      @engine         = options.fetch(:engine, :net_http)
      @headless       = options.fetch(:headless, true)
      @user_agent     = options.fetch(:user_agent, 'Makuri browser agent')

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

      return follow if browser_engine == 'Ferrum'

      @request_method = options.fetch(:method, request_method)
      @request_body   = options.fetch(:body, request_body)
      browser.visit(@url)
    end

    def quit
      browser.respond_to?(:quit) ? browser.quit : nil
    end

    def page
      browser.respond_to?(:page) ? browser.page : browser
    end

    def current_response
      browser.respond_to?(:current_response) ? browser.current_response : nil
    end

    private

    # Only allow for capybara get request
    def follow
      browser.visit(@url)
      browser
    end

    def create_browser
      builder = Object.const_get "Makuri::BrowserBuilder::#{browser_engine}"
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

    def browser_engine
      engine == :ferrum ? 'Ferrum' : 'NetHttp'
    end
  end
end
