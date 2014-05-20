unless ENV['HEROKU']

  require "require_all"
  require_all File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'jobbr'))

  namespace :jobbr do

    Jobbr::Ohm.models(Jobbr::Scheduled).each do |model|
      # dynamically create a rake task for each individual Jobbr::ScheduledJob
      desc model.description
      task model.task_name => :environment do
        model.run
      end
    end

    desc 'Mark all running job as failed.'
    task :sweep_running_jobs => :environment do
      Jobbr::Run.where(status: :running).update_all(status: :failure)
    end

  end

end
