module ScheduledJobs

  class DummyHerokuJob < Jobbr::Job

    include Jobbr::Scheduled

    description 'Describe your job here'

    heroku_run :daily, priority: 0

    def perform(run)
      run.logger.debug 'heroku :)'
    end

  end

end
