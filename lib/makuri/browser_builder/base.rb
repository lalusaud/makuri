module Makuri::BrowserBuilder
  class Base
    attr_accessor :user_agent, :request_method, :request_body, :blocked_filetypes

    def initialize(options = {})
      @user_agent     = options.fetch(:user_agent, '')
      @request_method = options.fetch(:request_method, :get)
      @request_body   = options.fetch(:request_body, '')
      @blocked_filetypes = options.fetch(:blocked_filetypes, [])
    end

    def build
      raise NotImplementedError
    end
  end
end
