require './config/environment'

use Honeybadger::Rack::ErrorNotifier
run Hanami.app
