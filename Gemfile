source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'sassc'
gem 'pg'

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
  gem 'capybara'
end

group :production do
  # gem 'puma'
end
