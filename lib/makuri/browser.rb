module Makuri
  class Browser
    attr_accessor :url, :render_js, :user_agent, :request_method, :request_body

    def initialize(options = {})
      @url            = options.fetch(:url, '')
      @request_method = options.fetch(:request_method, :get)
      @request_body   = options.fetch(:request_body, {})

      @render_js      = options.fetch(:render_js, false)
      @user_agent     = options.fetch(
        :user_agent,
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36'
      )
    end

    def follow(current_url = '')
      @url = current_url unless current_url.empty?
      raise 'Invalid URL supplied' if url.empty?

      @browser = create_browser
      @browser.visit(url)
    end

    private

    def create_browser
      engine = render_js ? 'Chrome' : 'NetHttp'
      builder = Object.const_get "Makuri::BrowserBuilder::#{engine}"
      builder.new browser_params
    end

    def browser_params
      {
        user_agent: user_agent,
        request_method: request_method,
        request_body: request_body
      }
    end
  end
end
