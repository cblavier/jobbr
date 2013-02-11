#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
load APP_RAKEFILE

# === Gems install tasks ===
Bundler::GemHelper.install_tasks

desc 'Run Rspec tests'
task :default do
  ["rspec spec"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :push_gem do
  puts "Building gem (version: #{Jobbr::VERSION})"
  system "gem build jobbr.gemspec"
  puts 'Pushing to rubygems.org'
  system "gem push jobbr-#{Jobbr::VERSION}.gem"
end