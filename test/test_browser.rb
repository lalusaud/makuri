# frozen_string_literal: true

require_relative 'test_helper'

class BrowserTest < Minitest::Test
  def setup
    @url = 'https://www.example.com'
  end

  def test_invalid_url
    err = assert_raises(RuntimeError) { Makuri::Browser.new.follow('invalid_url') }
    assert_equal err.message, 'Invalid URL supplied'
  end

  def test_run
    stub_request(:get, @url).to_return(body: 'test')

    res = Makuri::Browser.new.request(@url)
    assert_equal res, 'test'
  end

  def test_run_with_post_data
    stub_request(:post, @url).with(body: 'param1=test').to_return(body: 'test')

    res = Makuri::Browser.new.request(@url, { method: :post, body: 'param1=test' })
    assert_equal res, 'test'
  end

  def test_run_with_js
    # Selenium Webdriver makes call to remote site, need to find a way to mock this
    res = Makuri::Browser.new(engine: :chrome).follow(@url)
    assert_includes res.body, 'Example Domain'
  end
end
