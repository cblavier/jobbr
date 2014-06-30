module Jobbr

  class Job < ::Ohm::Model

    MAX_RUN_PER_JOB = 5000

    include ::Ohm::Timestamps
    include ::Ohm::DataTypes
    include ::Ohm::Callbacks

    attribute :type
    attribute :delayed, Type::Boolean

    collection :runs, 'Jobbr::Run'

    index :type
    index :delayed

    def self.instance(instance_class_name = nil)
      if instance_class_name
        job_class = instance_class_name.camelize.constantize
      else
        job_class = self
      end

      job = Job.find(type: job_class.to_s).first
      if job.nil?
        delayed = job_class.included_modules.include?(Jobbr::Delayed)
        job = Job.create(type: job_class.to_s, delayed: delayed)
      end
      job
    end

    def self.run_by_name(name, *args)
      instance(name).run(*args)
    end

    def self.run(*args)
      instance.run(*args)
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

    # overriding Ohm find to get Sidekiq to find job instances
    def self.find(id)
      if id.instance_of?(Hash)
        super
      elsif job = Jobbr::Job[id]
        job.send(:typed_self)
      end
    end

    def run(params = {}, delayed = true)
      job_run = Run.create(status: :waiting, started_at: Time.now, job: self)
      if delayed && self.delayed && !Rails.env.test?
        delayed_options = { retry: 0, backtrace: true }
        delayed_options[:queue] = typed_self.class.queue if typed_self.class.queue
        typed_self.delay(delayed_options).inner_run(job_run.id, params)
      else
        self.inner_run(job_run.id, params)
      end
      job_run
    end

    def handle_process_interruption(job_run, signals)
      signals.each do |signal|
        Signal.trap(signal) do
          job_run.status = :failed
          job_run.logger.error("Job interrupted by a #{signal} signal")
          job_run.finished_at = Time.now
          job_run.save
        end
      end
    end

    def every
      if scheduled?
        require self.type.underscore
        Object::const_get(self.type).every
      else
        nil
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
      self.runs.sort_by(:started_at, order: 'ALPHA DESC')
    end

    def after_delete
      self.runs.each(&:delete)
    end

    def perform
      raise NotImplementedError.new :message => 'Must be implemented'
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
        runs.sort_by(:started_at, order: 'ALPHA ASC', limit: [0, runs_count - max_run_per_job]).each do |run|
          if run.status == :failed || run.status == :success
            run.delete
          end
        end
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
        job_run.logger.debug("Starting with params #{params.inspect}")
        perform(job_run, params)
        job_run.status = :success
        job_run.progress = 100
      rescue Exception => e
        job_run.status = :failed
        job_run.logger.error(e.message)
        job_run.logger.error(e.backtrace)
        raise e
      ensure
        job_run.finished_at = Time.now
        job_run.save
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
      @typed_self ||= Object::const_get(self.type).new(id: self.id)
    end

  end

end
