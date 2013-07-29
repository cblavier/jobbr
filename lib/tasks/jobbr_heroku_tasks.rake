require "jobbr/mongoid.rb"

namespace :jobbr do

  namespace :heroku do

    desc 'Run all minutely Heroku jobs'
    task :minutely => :environment do
      run_heroku_scheduled_classes(:minutely)
    end

    desc 'Run all hourly Heroku jobs'
    task :hourly => :environment do
      run_heroku_scheduled_classes(:hourly)
    end

    desc 'Run all daily Heroku jobs'
    task :daily => :environment do
      run_heroku_scheduled_classes(:daily)
    end

    def run_heroku_scheduled_classes(frequency)
      load "jobbr/scheduled_job"
      Jobbr::Mongoid.models(Jobbr::ScheduledJob).select{|c| c.heroku_frequency == frequency }.sort{|a,b| b.heroku_priority <=> a.heroku_priority}.each(&:run)
    end

  end

end