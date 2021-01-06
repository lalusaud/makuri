# Makuri

Makuri is a Web-crawling framework for Ruby.

# Usage
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
