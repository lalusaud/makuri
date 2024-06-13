require 'ferrum'

module Makuri::BrowserBuilder
  class Ferrum < Base
    attr_accessor :headless, :timeout, :html, :ferrum_browser

    def initialize(options = {})
      super
      @headless = options.fetch(:headless, true)
      @timeout = options.fetch(:timeout, 60)
    end

    def build
      @ferrum_browser = ::Ferrum::Browser.new(browser_options)
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

    def browser_options
      {
        headless: headless,
        timeout: timeout,
        headers: { 'User-Agent': user_agent }
      }
    end
  end
end
