# frozen_string_literal: true

require 'addressable'
require 'nokogiri'

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
      end

      def run
        raise "Start URLs not found. Define start_urls for #{self}." unless defined? @start_urls

        @engine ||= :net_http

        new(start_urls: @start_urls, engine: @engine).parse
      end
    end

    attr_accessor :start_urls, :engine, :response

    def initialize(**config)
      @start_urls = config.fetch(:start_urls, nil)
      @engine     = config.fetch(:engine, :net_http)

      update_response(@start_urls[0])
    end

    def browser
      @browser ||= Makuri::Browser.new(engine: engine)
    end

    def parse
      raise NotImplementedError, "Define #parse method for #{self.class}."
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
      Addressable::URI.join(browser.url.to_s, relative_url).to_s
    end

    private

    def valid_url?(url)
      defined?(url) && !url.to_s.empty?
    end

    def update_response(url)
      html = browser.request absolute_url(url)
      @response = Nokogiri::HTML(html)
    end
  end
end
