require 'bundler/setup'

require 'tilt'
require 'sprockets'
require 'sprockets/helpers'

require 'soupcms/common'
require 'soupcms/core'
require 'soupcms/api'

require 'newrelic_rpm'
require 'new_relic/agent/instrumentation/rack'

if ENV['RACK_ENV'] == 'production'
  SoupCMS::Common::Util::HttpCacheStrategy.default_max_age = 3600
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
    config.data_resolver.register(/content$/,SoupCMS::Api::Resolver::KramdownMarkdownResolver)
    config.application_strategy = SoupCMS::Common::Strategy::Application::SubDomainBased
  end

  SoupCMSApiRackApp.class_eval do
    include ::NewRelic::Agent::Instrumentation::Rack
  end
  run SoupCMSApiRackApp.new
end

map '/' do
  SoupCMSCore.configure do |config|
    config.template_manager.prepend_store(SoupCMS::Core::Template::FileStore.new(SITE_TEMPLATE_DIR))
    config.application_strategy = SoupCMS::Common::Strategy::Application::SubDomainBased
  end

  SoupCMSRackApp.class_eval do
    include ::NewRelic::Agent::Instrumentation::Rack
  end
  app = SoupCMSRackApp.new
  app.set_redirect('http://soupcms.com/','http://www.soupcms.com/home')
  app.set_redirect('http://www.soupcms.com/','http://www.soupcms.com/home')
  app.set_redirect('http://blog.soupcms.com/','http://blog.soupcms.com/home')
  app.set_redirect('http://docs.soupcms.com/','http://docs.soupcms.com/home')

  app.router.add 'chapters/:release/:slug', SoupCMS::Core::Controller::ModelController, 'chapters'

  run app
end


