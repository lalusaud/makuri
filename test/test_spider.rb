require_relative 'test_helper'

class SpiderTest < Minitest::Test
  def setup
    @start_url = 'http://example.com'
    stub_request(:get, @start_url).to_return(body: '<h1>Example Domain</h1>')
  end

  def test_start_urls
    err = assert_raises(RuntimeError) { WithoutStartUrlsSpider.run }
    assert_equal err.message, 'Start URLs not found. Define start_urls for WithoutStartUrlsSpider.'
  end

  def test_parse_not_implemented
    err = assert_raises(NotImplementedError) { NoParseSpider.run }
    assert_equal err.message, 'Define #parse method for NoParseSpider.'
  end

  def test_browser
    browser = QuotesSpider.new(start_urls: [@start_url]).browser
    assert_instance_of Makuri::Browser, browser
  end

  def test_request_to
    spider = QuotesSpider.new(start_urls: [@start_url])
    response = spider.request_to :extract, url: @start_url
    assert_equal response, 'test'
  end

  def test_absolute_url
    spider = QuotesSpider.new(start_urls: [@start_url])
    url = spider.absolute_url('/test')
    assert_equal url, "#{@start_url}/test"
  end
end

class WithoutStartUrlsSpider
  include Makuri::Spider

  def parse; end
end

class NoParseSpider
  include Makuri::Spider
  start_urls ['http://example.com']
end

class QuotesSpider
  include Makuri::Spider
  start_urls ['http://example.com']

  def parse; end

  def extract
    'test'
  end
end
