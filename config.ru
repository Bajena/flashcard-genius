require './config/environment'

use Rack::SslEnforcer, only_environments: 'production'
use Honeybadger::Rack::ErrorNotifier
run Hanami.app
