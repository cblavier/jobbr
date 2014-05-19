module ScheduledJobs

  class LoggingJob < Jobbr::Job

    include Jobbr::Scheduled

    def perform(run)
      run.logger.debug 'foo'
      run.logger.error 'bar'
    end

  end

end
