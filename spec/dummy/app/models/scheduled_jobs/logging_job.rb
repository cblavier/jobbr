module ScheduledJobs

  class LoggingJob < Jobbr::ScheduledJob
    def perform
      Rails.logger.debug 'foo'
      Rails.logger.error 'bar'
    end
  end

end
