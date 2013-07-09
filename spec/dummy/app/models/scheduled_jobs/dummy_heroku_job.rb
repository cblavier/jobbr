module ScheduledJobs

  class DummyHerokuJob < Jobbr::ScheduledJob

    description 'Describe your job here'

    heroku_run :daily, priority: 0

    def perform
      Rails.logger.debug 'heroku :)'
    end

  end

end