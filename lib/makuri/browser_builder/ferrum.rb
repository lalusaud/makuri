require 'ferrum'

module Makuri::BrowserBuilder
  class Ferrum < Base
    attr_accessor :headless, :html

    def initialize(options = {})
      super
      @headless      = options.fetch(:headless, true)
    end

    def build
      headers = { 'User-Agent': user_agent }
      @ferrum = ::Ferrum::Browser.new(headless: @headless, headers: headers)
      self
    end

    def visit(url)
      @ferrum.go_to url
      @html = @ferrum.body
      self
    end

    def quit
      @ferrum.quit
    end

    private

    # TODO:
    # def browser_options
    #   args = %w[
    #     --disable-gpu
    #     --no-sandbox
    #     --disable-translate
    #     --ignore-certificate-errors
    #   ]
    #   args << '--headless' if headless
    #   args << "--user-agent=#{user_agent}"
    #   args << "--blink-settings=imagesEnabled=#{enable_images}"
    #   Selenium::WebDriver::Chrome::Options.new(args: args)
    # end
  end
end
