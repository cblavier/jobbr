module Jobbr
  module ApplicationHelper

    include FontAwesome::Rails::IconHelper

    def delayed_job_creation_path(delayed_job_class, params = {})
      jobbr.delayed_jobs_path(params.merge(job_name: delayed_job_class.name.underscore))
    end

    def delayed_job_polling_path(id = ':job_id')
      jobbr.delayed_job_path(id)
    end

    def status_icon(job_status)
      css_class = "job-status #{job_status}"
      if job_status == :waiting
        fa_icon 'circle-blank', class: css_class
      elsif job_status == :running
        fa_icon 'refresh', class: "#{css_class} fa-spin"
      elsif job_status == :success
        fa_icon 'certificate', class: css_class
      else
        fa_icon 'exclamation-circle', class: css_class
      end
    end

    def display_scheduling(job)
      every = job.every
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
