unless ENV['HEROKU']

  require "require_all"
  require "ohm"
  require "ohm/contrib"
  require_all File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app', 'models', 'jobbr'))

  namespace :jobbr do

    ::Rails.application.eager_load!

    Jobbr::Ohm.models(Jobbr::Scheduled).each do |model|
      # dynamically create a rake task for each individual Jobbr::ScheduledJob
      #::Rails.application.eager_load!
      #desc info[:desc]
      #task info[:name] => :environment do
      #  info[:dependencies].each { |lib| load lib }
      #  info[:klass_name].constantize.run
      #end
      puts "declaring #{model.task_name}"
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
