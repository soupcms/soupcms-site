require 'rspec'
require 'soupcms/site'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with :rspec
  config.mock_with 'rspec-mocks'

  config.before(:suite) do
  end

  config.before(:each) do
  end

  config.after(:suite) do
  end

end
