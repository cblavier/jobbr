ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require "jobbr/whenever"

set :output, "#{path}/log/cron.log"
job_type :rake, "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

Jobbr::Whenever.schedule_jobs(self)