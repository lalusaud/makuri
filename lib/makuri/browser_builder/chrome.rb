require 'capybara'
require 'selenium-webdriver'

module Makuri::BrowserBuilder
  class Chrome < Base
    attr_accessor :headless, :enable_images

    def initialize(options = {})
      super
      @headless      = options.fetch(:headless, true)
      @enable_images = options.fetch(:enable_images, true)
    end

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
        --disable-gpu
        --no-sandbox
        --disable-translate
        --ignore-certificate-errors
      ]
      args << '--headless' if headless
      args << "--user-agent=#{user_agent}"
      args << "--blink-settings=imagesEnabled=#{enable_images}"
      Selenium::WebDriver::Chrome::Options.new(args: args)
    end
  end
end
