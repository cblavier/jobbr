source "http://rubygems.org"

gemspec

gem 'rails', '>= 4.0.0'

# UI
gem 'jquery-rails'
gem 'haml'
gem 'chronic_duration'
gem 'sass-rails', '>= 4.0.2'
gem 'coffee-rails'
gem 'therubyracer'
gem 'less-rails'
gem 'bootstrap-sass'
gem 'font-awesome-rails'
gem 'turbolinks'

# Backend
gem 'redis'
gem 'ohm'
gem 'ohm-contrib', github: 'cyx/ohm-contrib'
gem 'sidekiq'
gem 'sidekiq-delay', github: 'cblavier/sidekiq-delay'
gem 'whenever'
gem 'require_all'

group :development do
  gem 'unicorn'
end

group :test do
  gem 'rspec-rails'
  gem 'mocha'
  gem 'database_cleaner'
  gem 'generator_spec'
  gem 'codeclimate-test-reporter', require: 'nil'
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'timecop'
end
