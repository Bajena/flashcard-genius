require './config/environment'
require 'raven'

# use Rack::SslEnforcer, only_environments: 'production'

Raven.configure do |config|
  config.dsn = 'https://c8c8e3886ba8444fb0506e81e3fe2da2@o462813.ingest.sentry.io/5466735'
end

use Raven::Rack
run Hanami.app
