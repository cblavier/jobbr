module Jobbr

  class DelayedJob < Jobbr::Job

    include Sidekiq::Delay

    def perform(params, run)
      raise NotImplementedError.new :message => 'Must be implemented'
    end

    def self.run(params, delayed = true)
      delayed = delayed && !Rails.env.test?
      job = instance
      job_run = Run.create(status: :waiting, started_at: Time.now, job: job)
      if delayed
        job.delay.inner_run(job_run.id, params)
      else
        job.inner_run(job_run.id, params)
      end
      job_run
    end

    def self.run_by_name(job_class_name, params, delayed = true)
      delayed = delayed && !Rails.env.test?
      job = instance(job_class_name)
      job_run = Run.create(status: :waiting, started_at: Time.now, job: job)
      if delayed
        job.delay.inner_run(job_run.id, params)
      else
        job.inner_run(job_run.id, params)
      end
      job_run
    end

  end

end
