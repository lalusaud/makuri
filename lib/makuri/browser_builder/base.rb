module Makuri::BrowserBuilder
  class Base
    attr_accessor :user_agent

    def initialize(options)
      @user_agent = options.fetch(:user_agent, 'Makuri')
    end
  end
end
