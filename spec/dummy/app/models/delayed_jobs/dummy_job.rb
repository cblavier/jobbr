module DelayedJobs

  class DummyJob < Jobbr::DelayedJob

    def perform(params, run)
      logger.debug 'job is running'
    end

  end

end
