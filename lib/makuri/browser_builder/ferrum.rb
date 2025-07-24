require 'ferrum'

module Makuri::BrowserBuilder
  class Ferrum < Base
    attr_accessor :headless, :browser_options, :timeout, :html, :ferrum_browser, :blocked_filetypes

    def initialize(options = {})
      super
      @headless = options.fetch(:headless, true)
      @timeout = options.fetch(:timeout, 60)
      @browser_options = options.fetch(:browser_options, {})
      @blocked_filetypes = options.fetch(:blocked_filetypes, [])
    end

    def build
      @ferrum_browser = ::Ferrum::Browser.new(browser_params)
      self
    end

    def visit(url)
      setup_request_blocking if blocked_filetypes.any? && !@request_blocking_setup
      page.go_to url
      @html = page.body
      self
    end

    def quit
      ferrum_browser.quit
    end

    def page
      @page ||= ferrum_browser.create_page
    end

    def current_response
      Nokogiri::HTML page.body
    end

    private

    def setup_request_blocking
      return if @request_blocking_setup
      
      # Enable network domain and set up request interception
      page.command('Network.enable')
      page.command('Network.setRequestInterception', patterns: [{ urlPattern: '*' }])
      
      page.on('Network.requestIntercepted') do |params|
        request_url = params['request']['url']
        
        # Check if the request URL matches any of the blocked filetypes
        should_block = blocked_filetypes.any? do |filetype|
          request_url.match?(/\.#{Regexp.escape(filetype)}(\?|$)/i)
        end
        
        if should_block
          page.command('Network.continueInterceptedRequest', 
                      interceptionId: params['interceptionId'],
                      errorReason: 'Aborted')
        else
          page.command('Network.continueInterceptedRequest', 
                      interceptionId: params['interceptionId'])
        end
      end
      
      @request_blocking_setup = true
    end

    def browser_params
      {
        headless: headless,
        timeout: timeout,
        headers: { 'User-Agent': user_agent },
        browser_options: browser_options
      }
    end
  end
end
