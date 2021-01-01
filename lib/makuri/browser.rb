module Makuri
  class Browser
    attr_accessor :url, :headers

    def initialize(options = {})
      @url        = options.fetch(:url, '')
      @render_js  = options.fetch(:render_js, false)
      @user_agent = options.fetch(
        :user_agent,
        'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36'
      )
    end

    def run
      raise 'Invalid URL supplied' if url.to_s.empty?

      create_browser.visit(url)
    end

    private

    def create_browser
      engine = render_js ? 'Chrome' : 'NetHttp'
      builder = Object.const_get "Makuri::BrowserBuilder::#{engine}"
      builder.new browser_params
    end

    def browser_params
      {
        user_agent: user_agent
      }
    end
  end
end
