require 'capybara'
require 'selenium-webdriver'

module Makuri::BrowserBuilder
  class Chrome < Base
    def build
      Capybara.register_driver :selenium_chrome do |app|
        Capybara::Selenium::Driver.new app, browser: :chrome, options: browser_options
      end
      Capybara.threadsafe = true
      Capybara::Session.new :selenium_chrome
    end

    private

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
  end
end
