source "http://rubygems.org"

gemspec

# UI
gem 'jquery-rails'
gem 'whenever'
gem 'haml'
gem 'chronic_duration'
gem 'sass-rails'
gem 'coffee-rails'

# Backend
gem 'redis'
gem 'ohm'
gem 'ohm-contrib', github: 'cyx/ohm-contrib'
gem 'sidekiq'
gem 'sidekiq-delay', github: 'cblavier/sidekiq-delay'

group :development do
  gem 'unicorn'
end

group :test do
  gem 'rspec-rails'
  gem 'mocha'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: 'nil'
end
