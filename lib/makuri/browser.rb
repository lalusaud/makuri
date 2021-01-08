module Makuri
  class Browser
    attr_accessor :url, :js, :user_agent, :request_method, :request_body

    def initialize(options = {})
      @url            = options.fetch(:url, '')
      @request_method = options.fetch(:request_method, :get)
      @request_body   = options.fetch(:request_body, {})

      @js             = options.fetch(:js, false)
      @user_agent     = options.fetch(
        :user_agent,
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36'
      )
    end

    def browser
      @browser ||= create_browser
    end

    # Only allow for capybara get request
    def follow(current_url = '')
      @url = current_url unless current_url.empty?
      raise 'Invalid URL supplied' if url.empty?

      raise invalid_request_without_get if request_method != :get

      browser.visit(url)
      browser
    end

    # Allow for NetHttp get request
    def request(current_url = '')
      @url = current_url unless current_url.empty?
      raise 'Invalid URL supplied' if url.empty?

      raise 'Invalid request type for js=true. Use #follow in place of #get' if js

      browser.visit(url).body
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
        request_method: request_method,
        request_body: request_body
      }
    end

    def invalid_request_without_get
      "#{request_method.to_s.upcase} request not allowed for JS Engine. Try without 'js=true' argument!"
    end
  end
end
