module ScheduledJobs

  class DummyJob < Jobbr::Job

    include Jobbr::Scheduled

    # description 'Describe your job here'

    # every 1.day, at: '5am'

    def perform
      # put your job code here
    end

  end

end
