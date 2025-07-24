# frozen_string_literal: true

require 'addressable'
require 'nokogiri'
require 'logger'

module Makuri
  ##
  # Include this module in your spider class
  module Spider
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def start_urls(urls)
        raise 'Invalid format for start_urls. Pass urls in an array.' unless urls.is_a? Array

        @start_urls = urls
      end

      def spider_options(**options)
        @engine = options.fetch(:engine, :net_http)
        @headless = options.fetch(:headless, true)
        @browser_options = options.fetch(:browser_options, {})
        @blocked_filetypes = options.fetch(:blocked_filetypes, [])
      end

      def run
        raise "Start URLs not found. Define start_urls for #{self}." unless defined? @start_urls

        @engine ||= :net_http
        @headless = defined?(@headless) ? @headless : true
        @browser_options ||= {}
        @blocked_filetypes ||= []

        @start_urls.each do |start_url|
          spider = new(start_url: start_url, engine: @engine, headless: @headless, browser_options: @browser_options, blocked_filetypes: @blocked_filetypes)
          spider.start
          spider.parse
          spider.browser.quit
          spider.finish
        end
      end
    end

    attr_accessor :engine, :headless, :browser_options, :blocked_filetypes, :response, :logger

    def initialize(**config)
      @start_url = config.fetch(:start_url, nil)
      @engine    = config.fetch(:engine, :net_http)
      @headless  = config.fetch(:headless, true)
      @logger    = Logger.new(STDOUT)
      @browser_options = config.fetch(:browser_options, {})
      @blocked_filetypes = config.fetch(:blocked_filetypes, [])

      update_response(@start_url)
    end

    def browser
      @browser ||= Makuri::Browser.new(engine: engine, headless: headless, browser_options: browser_options, blocked_filetypes: blocked_filetypes)
    end

    def parse
      raise NotImplementedError, "Define #parse method for #{self.class}."
    end

    def start
      logger.info('Spider starting.')
    end

    def finish
      logger.info('Spider finished.')
    end

    def request_to(handler, **params)
      if valid_url? params[:url]
        update_response(params[:url])
        params.delete :url
      end

      if params.empty?
        public_send handler
      else
        public_send handler, params
      end
    end

    def absolute_url(relative_url)
      Addressable::URI.join(base_url, relative_url).to_s
    end

    private

    def base_url
      @start_url || browser.url.to_s
    end

    def valid_url?(url)
      defined?(url) && !url.to_s.empty?
    end

    def update_response(url)
      res = browser.request(absolute_url(url)).html
      @response = Nokogiri::HTML(res)
    end
  end
end
