module DelayedJobs

  class OtherDummyJob < Jobbr::DelayedJob

    def perform(run, params)
      run.logger.debug 'job is running'
    end

  end

end
