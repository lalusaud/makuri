require 'ferrum'

module Makuri::BrowserBuilder
  class Ferrum < Base
    attr_accessor :headless, :browser_options, :timeout, :html, :ferrum_browser

    def initialize(options = {})
      super
      @headless = options.fetch(:headless, true)
      @timeout = options.fetch(:timeout, 60)
      @browser_options = options.fetch(:browser_options, {})
    end

    def build
      @ferrum_browser = ::Ferrum::Browser.new(browser_params)
      self
    end

    def visit(url)
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
