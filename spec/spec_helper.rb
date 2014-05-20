ENV['RAILS_ENV'] ||= 'test'

if ENV['CI'] == 'true'
  ENV['CODECLIMATE_REPO_TOKEN'] ||= 'edafaf863fa93aff340625ec4ac8d70244456849256d0b4b16383ca0a76a11ec'
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require File.join(File.dirname(__FILE__), 'dummy', 'config', 'environment.rb')
require 'require_all'
require 'rspec/rails'
require 'generator_spec'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'timecop'

require_all Rails.root.join('..','..','lib','generators','jobbr', '**/*_generator.rb')
require_all File.join(File.dirname(__FILE__), 'support', '**', '*.rb')

SPEC_TMP_ROOT = Pathname.new(Dir.tmpdir)

RSpec.configure do |config|

  Capybara.javascript_driver = :poltergeist
  config.mock_with :mocha

  config.include GeneratorSpec::TestCase,           type: :generator
  config.include GeneratorDestinationRoot,          type: :generator
  config.include RSpec::Rails::RequestExampleGroup, type: :feature

  config.before(:each, type: :generator) do
    FileUtils.rm_rf(SPEC_TMP_ROOT)
    prepare_destination
  end

  config.after(:each, type: :generator) do
    FileUtils.rm_rf(SPEC_TMP_ROOT)
  end

  config.before(:each) do
    clean_redis
  end

  config.after(:all) do
    Timecop.return
    clean_redis
  end

  def clean_redis
    Ohm.redis.call("KEYS", "Jobbr::*").each{|key| Ohm.redis.call('DEL', key)}
  end

end
