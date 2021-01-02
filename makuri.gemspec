require_relative 'lib/makuri/version'

Gem::Specification.new do |spec|
  spec.name          = 'makuri'
  spec.version       = Makuri::VERSION
  spec.summary       = 'Web-crawling framework for Ruby'
  spec.homepage      = 'https://github.com/lalusaud/makuri'
  spec.license       = 'MPL-2.0'

  spec.author        = 'Lal Saud'
  spec.email         = 'lalusaud@gmail.com'

  spec.files         = Dir['*.{md,txt}', '{lib}/**/*']
  spec.require_path  = 'lib'

  spec.required_ruby_version = '>= 2.5'

  spec.add_runtime_dependency 'selenium-webdriver', '~> 3.142'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'webmock', '~> 3.11'
end
