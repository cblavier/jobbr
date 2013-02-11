require "jobbr/mongoid"

module Jobbr

  module Whenever

    extend self

    #
    # Generates crontab for each scheduled Job using Whenever DSL.
    #
    def schedule_jobs(job_list)
      Jobbr::Mongoid.models(Jobbr::ScheduledJob).each do |job|
        if job.every
          job_list.every job.every[0], job.every[1] do
            job_list.rake job.task_name(true)
          end
        end
      end
    end

  end

end
