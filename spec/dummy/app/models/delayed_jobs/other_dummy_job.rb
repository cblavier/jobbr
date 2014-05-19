module DelayedJobs

  class OtherDummyJob < Jobbr::Job

    include Jobbr::Delayed

    def perform(run, params)
      run.logger.debug 'job is running'
    end

  end

end
