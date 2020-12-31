require_relative 'test_helper'

class MakuriTest < Minitest::Test
  def test_invalid_url
    err = assert_raises(RuntimeError) { Makuri::Browser.new(url: '').run }
    assert_equal err.message, 'Invalid URL supplied'
  end

  def test_run
    url = 'http://www.example.com'
    stub_request(:get, url).to_return(body: 'test')

    req = Makuri::Browser.new(url: url).run
    assert_equal req, 'test'
  end
end
