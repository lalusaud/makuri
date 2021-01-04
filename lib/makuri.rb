# frozen_string_literal: true

require 'makuri/browser'
require 'makuri/spider'
require 'makuri/version'

require 'makuri/browser_builder/base'
require 'makuri/browser_builder/chrome'
require 'makuri/browser_builder/net_http'

module Makuri
  class Error < StandardError; end
end
