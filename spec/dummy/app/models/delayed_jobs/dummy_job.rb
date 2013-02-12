module DelayedJobs

  class DummyJob < Jobbr::DelayedJob

    def perform(params, run)
      # put your job code here
    end

  end

end
