source "http://rubygems.org"

gemspec

gem 'rails', '>= 4.0.0'

# UI
gem 'jquery-rails'
gem 'haml'
gem 'chronic_duration'
gem 'sass-rails', '>= 4.0.2'
gem 'coffee-rails'

# Backend
gem 'redis'
gem 'ohm'
gem 'ohm-contrib', github: 'cyx/ohm-contrib'
gem 'sidekiq'
gem 'sidekiq-delay', github: 'cblavier/sidekiq-delay'
gem 'whenever'

group :development do
  gem 'unicorn'
end

group :test do
  gem 'rspec-rails'
  gem 'mocha'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: 'nil'
end
