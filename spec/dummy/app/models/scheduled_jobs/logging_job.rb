module ScheduledJobs

  class LoggingJob < Jobbr::ScheduledJob

    def perform(run)
      run.logger.debug 'foo'
      run.logger.error 'bar'
    end
    
  end

end
