# Makuri

Makuri is a Web-crawling framework for Ruby.

# Install

Add this to your application's Gemfile
```ruby
gem 'makuri'
```
And execute
```sh
$ bundle
```
Or install it as:
```sh
$ gem install makuri
```

# Usage

### Example - 1
In this example, we are going to crawl the [quotes website](https://quotes.toscrape.com) and scrape data as:
```ruby
# quotes_spider.rb
require 'makuri'

class QuotesSpider
  include Makuri::Spider
  start_urls ['https://quotes.toscrape.com/tag/humor/']

  def parse
    response.css('div.quote').each { |quote| extract(quote) }

    next_page = response.at_css('li.next>a')
    request_to :parse, url: next_page[:href] unless next_page.nil?
  end

  def extract(quote)
    item = {
      author: quote.at_css('span>small').text,
      text: quote.at_css('span.text').text
    }

    puts item.to_json
  end
end

QuotesSpider.run
```
Now save the file to ```quotes_spider.rb``` file and run it as:
```sh
$ ruby quotes_spider.rb > quotes.json
```
When it's done, you will find all the quotes saved to ```quotes.json``` file. It's that easy.


### Example - 2
Now, let's try to scrape another site with JavaScript rendered site with Dynamic HTML and infinite scroll:
```ruby
# infinite_scroll_spider.rb
require 'makuri'

class InfiniteScrollSpider
  include Makuri::Spider
  spider_options engine: :ferrum, headless: true

  start_urls ['https://infinite-scroll.com/demo/full-page/']

  def parse
    post_title_xpath = '//article/h2'
    count = response.xpath(post_title_xpath).count

    current_response = nil
    loop do
      browser.page.execute('window.scrollBy(0,10000)'); sleep 2

      current_response = browser.current_response
      new_count = current_response.xpath(post_title_xpath).count

      logger.info '> Pagination is done' and break if count == new_count

      count = new_count
      logger.info "> Continue scrolling, current count is #{count}..."
    end

    posts_headers = current_response.xpath(post_title_xpath).map(&:text)
    logger.info "> All post titles: #{posts_headers.join('; ')}"
  end
end
```
Now save the file to ```infinite_scroll_spider.rb``` and run it as:
```sh
$ ruby infinite_scroll_spider.rb
```

## History

View the [changelog](https://github.com/lalusaud/makuri/blob/main/CHANGELOG.md)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/lalusaud/makuri/issues)
- Fix bugs and [submit pull requests](https://github.com/lalusaud/makuri/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
$ git clone https://github.com/lalusaud/makuri.git
$ cd makuri
$ bundle install
$ bundle exec rake test
```
