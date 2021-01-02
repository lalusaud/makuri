require_relative 'test_helper'

class MakuriTest < Minitest::Test
  def test_invalid_url
    err = assert_raises(RuntimeError) { Makuri::Browser.new(url: '').run }
    assert_equal err.message, 'Invalid URL supplied'
  end

  def test_run
    url = 'http://www.example.com'
    stub_request(:get, url).to_return(body: 'test')

    res = Makuri::Browser.new(url: url).run
    assert_equal res, 'test'
  end

  def test_run_with_js
    url = 'http://www.example.com'

    # Selenium Webdriver makes call to remote site, need to find a way to mock this
    res = Makuri::Browser.new(url: url, render_js: true).run
    assert_includes res, 'Example Domain'
  end
end
