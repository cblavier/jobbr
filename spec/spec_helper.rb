ENV['RAILS_ENV'] ||= 'test'

ENV['CODECLIMATE_REPO_TOKEN'] ||= 'edafaf863fa93aff340625ec4ac8d70244456849256d0b4b16383ca0a76a11ec'
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.join(File.dirname(__FILE__), 'dummy', 'config', 'environment.rb')
require 'rspec/rails'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|

  config.mock_with :mocha

  config.before(:suite) do
    DatabaseCleaner.orm = 'ohm'
  end

  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:suite) do
    #DatabaseCleaner.clean_with(:truncation)
  end

end
