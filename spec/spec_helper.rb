ENV['RAILS_ENV'] ||= 'test'
ENV['CODECLIMATE_REPO_TOKEN'] ||= 'edafaf863fa93aff340625ec4ac8d70244456849256d0b4b16383ca0a76a11ec'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.join(File.dirname(__FILE__), 'dummy', 'config', 'environment.rb')
require 'require_all'
require 'rspec/rails'
require 'database_cleaner'
require 'generator_spec'

require_all Rails.root.join('..','..','lib','generators','jobbr', '**/*_generator.rb')
require_all File.join(File.dirname(__FILE__), 'support', '**', '*.rb')

SPEC_TMP_ROOT = Pathname.new(Dir.tmpdir)

RSpec.configure do |config|

  config.mock_with :mocha
  config.include GeneratorSpec::TestCase,  type: :generator
  config.include GeneratorDestinationRoot, type: :generator

  config.before(:each, type: :generator) do
    FileUtils.rm_rf(SPEC_TMP_ROOT)
    prepare_destination
  end

  config.after(:each, type: :generator) do
    FileUtils.rm_rf(SPEC_TMP_ROOT)
  end

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
