require './config/environment'

use Honeybadger::Rack::ErrorNotifier
use Rack::ContentLength
run Hanami.app
