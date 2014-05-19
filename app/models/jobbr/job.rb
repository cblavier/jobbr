require 'jobbr/logger'
require 'jobbr/ohm'

module Jobbr

  class Job < ::Ohm::Model

    MAX_RUN_PER_JOB = 500

    include ::Ohm::Timestamps
    include ::Ohm::DataTypes
    include ::Ohm::Callbacks

    attribute :type
    attribute :delayed, Type::Boolean

    collection :runs, 'Jobbr::Run'

    index :type
    index :delayed

    def self.instance(instance_type = nil)
      if instance_type
        job_class = instance_type.camelize.constantize
      else
        job_class = self
      end

      job = Job.find(type: job_class.to_s).first
      if job.nil?
        delayed = job_class.new.is_a?(Jobbr::DelayedJob)
        job = Job.create(type: job_class.to_s, delayed: delayed)
      end
      job
    end

    def self.run
      job_run = Run.create(status: :running, started_at: Time.now, job: self.instance)
      instance.inner_run(job_run.id)
    end

    def self.description(desc = nil)
      @description = desc if desc
      @description
    end

    def self.delayed
      find(delayed: true)
    end

    def self.scheduled
      find(delayed: false)
    end

    def self.count
      all.count
    end

    def self.by_name(name)
      class_name = name.underscore.camelize
      Job.find(type: class_name).first
    end

    def every
      if scheduled?
        require self.type.underscore
        Object::const_get(self.type).every
      else
        nil
      end
    end

    def inner_run(job_run_id, params = {})
      job_run = Run[job_run_id]
      job_run.status = :running
      job_run.started_at = Time.now
      job_run.save

      cap_runs!

      handle_process_interruption(job_run, ['TERM', 'INT'])

      begin
        perform(job_run, params)
        job_run.status = :success
        job_run.progress = 100
      rescue Exception => e
        job_run.status = :failure
        job_run.logger.error(e.message)
        job_run.logger.error(e.backtrace)
        raise e
      ensure
        job_run.finished_at = Time.now
        job_run.save
      end
    end

    def handle_process_interruption(job_run, signals)
      signals.each do |signal|
        Signal.trap(signal) do
          job_run.status = :failure
          job_run.logger.error("Job interrupted by a #{signal} signal")
          job_run.finished_at = Time.now
          job_run.save
        end
      end
    end

    def last_run
      @last_run ||= self.ordered_runs.first
    end

    def average_run_time
      return 0 if runs.empty?
      (runs.map { |run| run.run_time }.compact.inject { |sum, el| sum + el }.to_f / runs.count).round(2)
    end

    def to_param
      self.type.underscore.dasherize.gsub('/', '::')
    end

    def name
      self.type.demodulize.underscore.humanize
    end

    def scheduled?
      !self.delayed
    end

    def delayed?
      self.delayed
    end

    def ordered_runs
      self.runs.sort(by: :started_at, order: 'DESC')
    end

    def after_delete
      self.runs.each(&:delete)
    end

    protected

    # mocking purpose
    def max_run_per_job
      MAX_RUN_PER_JOB
    end

    # prevents Run collection to grow beyond max_run_per_job
    def cap_runs!
      runs_count = self.runs.count
      if runs_count > max_run_per_job
        runs.sort(by: :started_at, order: 'ASC', limit: [0, runs_count - max_run_per_job]).each(&:delete)
      end
    end

    def perform(job_run, params)
      case typed_self.method(:perform).parameters.length
      when 0 then typed_self.perform
      when 1 then typed_self.perform(job_run)
      when 2 then typed_self.perform(job_run, params)
      end
    end

    # working around lack of polymorphism in Ohm
    # using type attributed to get a typed instance
    def typed_self
      @typed_self ||= Object::const_get(self.type).new
    end

  end

end
