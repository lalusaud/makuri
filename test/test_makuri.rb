require_relative 'test_helper'

class MakuriTest < Minitest::Test
  def setup
    @url = 'http://www.example.com'
  end

  def test_invalid_url
    err = assert_raises(RuntimeError) { Makuri::Browser.new(url: '').run }
    assert_equal err.message, 'Invalid URL supplied'
  end

  def test_run
    stub_request(:get, @url).to_return(body: 'test')

    res = Makuri::Browser.new(url: @url).run
    assert_equal res, 'test'
  end

  def test_run_with_post_data
    stub_request(:post, @url).with(body: 'param1=test').to_return(body: 'test')

    params = {
      url: @url,
      request_method: :post,
      request_body: 'param1=test'
    }
    res = Makuri::Browser.new(params).run
    assert_equal res, 'test'
  end

  def test_run_with_js
    # Selenium Webdriver makes call to remote site, need to find a way to mock this
    res = Makuri::Browser.new(url: @url, render_js: true).run
    assert_includes res, 'Example Domain'
  end

  def test_run_with_js_and_post
    err = assert_raises(RuntimeError) { Makuri::Browser.new(url: @url, render_js: true, request_method: :post).run }
    assert_includes err.message, 'POST request not allowed for JS Engine'
  end
end
