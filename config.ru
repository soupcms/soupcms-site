require 'tilt'
require 'sprockets'
require 'sprockets/helpers'
require 'rack/cache'
require 'faraday'
require 'faraday_middleware'

require 'soupcms/core'
require 'soupcms/api'


use Rack::Cache,
    :metastore => 'heap:/',
    :entitystore => 'heap:/',
    :verbose => false

# http client with caching based on cache headers
SoupCMS::Core::Utils::HttpClient.connection = Faraday.new do |faraday|
  faraday.use FaradayMiddleware::RackCompatible, Rack::Cache::Context,
              :metastore => 'heap:/',
              :entitystore => 'heap:/',
              :verbose => false,
              :ignore_headers => %w[Set-Cookie X-Content-Digest]

  faraday.adapter Faraday.default_adapter
end

SITE_TEMPLATE_DIR = File.join(File.dirname(__FILE__), 'ui')
PUBLIC_DIR = File.join(File.dirname(__FILE__), 'public')

map '/assets' do
  sprockets = SoupCMSCore.config.sprockets
  sprockets.append_path SoupCMS::Core::Template::Manager::DEFAULT_TEMPLATE_DIR
  sprockets.append_path SITE_TEMPLATE_DIR
  sprockets.append_path PUBLIC_DIR
  Sprockets::Helpers.configure do |config|
    config.environment = sprockets
    config.prefix = '/assets'
    config.public_path = PUBLIC_DIR
    config.digest = true
  end
  run sprockets
end

map '/api' do
  SoupCMSApi.configure do |config|
    config.http_caching_strategy.default_max_age = 10*60 # 10 minutes
    config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
  end
  run SoupCMSApiRackApp.new
end

map '/' do
  SoupCMSCore.configure do |config|
    config.soupcms_api_host_url = 'http://localhost:9292/'
    config.template_manager.prepend_store(SoupCMS::Core::Template::FileStore.new(SITE_TEMPLATE_DIR))
  end
  run SoupCMSRackApp.new
end


