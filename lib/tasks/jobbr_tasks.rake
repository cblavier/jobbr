unless ENV['HEROKU']

  require "require_all"
  require "ohm"
  require "ohm/contrib"
  require_all File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'jobbr'))

  namespace :jobbr do

    Jobbr::Ohm.models(Jobbr::Scheduled).each do |model|
      desc model.description
      task model.task_name => :environment do
        model.run
      end
    end

    desc 'Mark all running job as failed.'
    task :sweep_running_jobs => :environment do
      Jobbr::Run.find(status: :running).each do |run|
        run.status = :failed
        run.save
      end
    end

  end

end
