source 'https://rubygems.org'

ruby "2.6.1"

gem 'rake'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'sassc'
gem 'pg'
gem 'bcrypt'
gem "hanami-ujs"
gem "prawn"
gem 'rack-ssl-enforcer'
gem "sentry-raven"
gem 'omniauth-google-oauth2'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
  gem "pry-rescue"
  gem "pry-stack_explorer"
  gem "pry-nav"
  gem "rb-fsevent", require: false  # mac os x
  gem "rb-readline" # Fix for pry history
end

group :test do
  gem 'rspec'
  gem 'rspec-hanami'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot'
end

group :production do
  # gem 'puma'
end
