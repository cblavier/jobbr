module ScheduledJobs

  class DummyScheduledJob < Jobbr::ScheduledJob

    description 'A dummy Job'

    every 1.day, at: '5.30 am'

    def perform(run)
      run.logger.debug 'Dummy!!!!'
    end

  end

end
