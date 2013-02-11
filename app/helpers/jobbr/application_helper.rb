module Jobbr
  module ApplicationHelper

    def delayed_job_creation_path(delayed_job_class, params = {})
      jobbr.delayed_jobs_path(params.merge(job_name: delayed_job_class.name.underscore))
    end

    def delayed_job_polling_path(id = ':job_id')
      jobbr.delayed_job_path(id)
    end

    def status_icon_class(job_status)
      if job_status == :waiting
        "job-status #{job_status} icon-circle-blank"
      elsif job_status == :running
        "job-status #{job_status} icon-refresh icon-spin"
      elsif job_status == :success
        "job-status #{job_status} icon-certificate"
      else
        "job-status #{job_status} icon-exclamation-sign"
      end
    end

    def display_scheduling(job)
      every = job.class.every
      if every
        scheduling = ChronicDuration.output(every[0])
        if every[1] && !every[1].empty?
          scheduling = "#{scheduling} at #{every[1][:at]}"
        end
        scheduling
      end
    end

  end
end