require 'capybara'
require 'selenium-webdriver'

module Makuri::BrowserBuilder
  class Chrome < Base
    def visit(url)
      raise invalid_request_message if request_method != :get

      browser.visit url
      browser.body
    end

    def browser
      @browser ||= create_browser
    end

    private

    def create_browser
      Capybara.register_driver :selenium_chrome do |app|
        Capybara::Selenium::Driver.new app, browser: :chrome, options: browser_options
      end
      Capybara.threadsafe = true
      Capybara::Session.new :selenium_chrome
    end

    def browser_options
      args = %w[
        --headless
        --disable-gpu
        --no-sandbox
        --disable-translate
        --blink-settings=imagesEnabled=false
        --ignore-certificate-errors
      ]
      args << "--user-agent=#{@user_agent}"
      Selenium::WebDriver::Chrome::Options.new(args: args)
    end

    def invalid_request_message
      "#{request_method.to_s.upcase} request not allowed for JS Engine. Try without 'render_js=true' argument!"
    end
  end
end
