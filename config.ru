require 'bundler/setup'
require 'tilt'
require 'sprockets'
require 'sprockets/helpers'
require 'rack/cache'
require 'faraday'
require 'faraday_middleware'

require 'soupcms/common'
require 'soupcms/core'
require 'soupcms/api'

puts "MONGODB_URI_www = #{ENV['MONGODB_URI_www']}"
puts "MONGODB_URI_blog = #{ENV['MONGODB_URI_blog']}"
puts "MONGODB_URI_docs = #{ENV['MONGODB_URI_docs']}"


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
    config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::RedcarpetMarkdownResolver)
    config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::KramdownMarkdownResolver)
    config.application_strategy = SoupCMS::Common::Strategy::Application::SubDomainBased
  end
  run SoupCMSApiRackApp.new
end

map '/' do
  SoupCMSCore.configure do |config|
    config.template_manager.prepend_store(SoupCMS::Core::Template::FileStore.new(SITE_TEMPLATE_DIR))
    config.application_strategy = SoupCMS::Common::Strategy::Application::SubDomainBased
  end
  run SoupCMSRackApp.new
end


