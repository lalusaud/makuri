require 'selenium-webdriver'

module Makuri::BrowserBuilder
  class Chrome < Base
    def visit(url)
      @browser = Selenium::WebDriver.for :chrome, options: browser_options
      @browser.get url
      @browser.page_source
    end

    private

    def browser_options
      args = %w[
        --headless --disable-gpu --no-sandbox --disable-translate
        --blink-settings=imagesEnabled=false --ignore-certificate-errors
      ]
      args << "--user-agent=#{user_agent}"
      Selenium::WebDriver::Chrome::Options.new(args: args)
    end
  end
end
