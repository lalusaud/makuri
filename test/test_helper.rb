require 'bundler/setup'
Bundler.require(:default)
require 'minitest/autorun'
require 'minitest/pride'

require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)
