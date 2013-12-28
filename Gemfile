source 'https://rubygems.org'

gemspec

gem 'sprockets', github: 'sstephenson/sprockets'

gem 'soupcms-core', path: '../soupcms-core'
gem 'soupcms-api', path: '../soupcms-api'
gem 'redcarpet'
gem 'kramdown'
gem 'coderay'

group :development do
  gem 'puma'
  gem 'rack-cache'
  gem 'faraday'
  gem 'faraday_middleware'
  gem 'mongo'
  gem 'bson_ext'
end

group :test do
  gem 'rspec', '~> 3.0.0.beta1'
  gem 'rake'
  gem 'rack-test'
end