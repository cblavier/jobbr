module Jobbr

  class DelayedJob < Jobbr::Job

    field :delayed, type: Boolean, default: true

    # hack to work around multiple inheritance issue with Mongoid
    default_scope ->{ Job.where(delayed: true, :_type.ne => nil) }

    def perform(params, run)
      raise NotImplementedError.new :message => 'Must be implemented'
    end

    def self.run_delayed(params, delayed = true)
      job = instance
      job_run = Run.create(status: :waiting, started_at: Time.now, job: job)
      if delayed
        job.delay.run(job_run, params)
      else
        job.run(job_run, params)
      end
      job_run
    end

    def self.run_delayed_by_name(job_class_name, params, delayed = true)
      job = instance(job_class_name)
      job_run = Run.create(status: :waiting, started_at: Time.now, job: job)
      if delayed
        job.delay.run(job_run, params)
      else
        job.run(job_run, params)
      end
      job_run
    end

  end

end