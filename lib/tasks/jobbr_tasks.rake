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

    task :minutely => :environment do
      heroku_scheduled_classes(:minutely).each(&:run)
    end

    task :hourly => :environment do
      heroku_scheduled_classes(:hourly).each(&:run)
    end

    task :daily => :environment do
      heroku_scheduled_classes(:daily).each(&:run)
    end

    def heroku_scheduled_classes(frequency)
      Jobbr::Mongoid.models(Jobbr::ScheduledJob).select{|c| c.heroku_frequency == frequency }.sort{|a,b| b.heroku_priority <=> a.heroku_priority}
    end

  end

end
