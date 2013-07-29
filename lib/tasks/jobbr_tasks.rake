models_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'models'))
require File.join(models_root, 'jobbr', 'standalone_tasks')
require "jobbr/mongoid.rb"

namespace :jobbr do

  Jobbr::StandaloneTasks.all(:scheduled_job).each do |info|
    # dynamically create a rake task for each individual Jobbr::ScheduledJob
    desc info[:desc]
    task info[:name] => :environment do
      info[:dependencies].each { |lib| load lib }
      info[:klass_name].constantize.run
    end
  end

  desc 'Mark all running job as failed.'
  task :sweep_running_jobs => :environment do
    Jobbr::Run.where(status: :running).update_all(status: :failure)
  end

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
      require "jobbr/scheduled_job"
      Jobbr::Mongoid.models(Jobbr::ScheduledJob).select{|c| c.heroku_frequency == frequency }.sort{|a,b| b.heroku_priority <=> a.heroku_priority}.each(&:run)
    end

  end

end
