module Makuri::BrowserBuilder
  class Base
    attr_accessor :user_agent, :request_method, :request_body

    def initialize(options)
      @user_agent     = options.fetch(:user_agent)
      @request_method = options.fetch(:request_method)
      @request_body   = options.fetch(:request_body)
    end
  end
end
