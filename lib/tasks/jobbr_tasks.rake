unless ENV['heroku']

  models_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'models'))
  require File.join(models_root, 'jobbr', 'standalone_tasks'

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

  end

end