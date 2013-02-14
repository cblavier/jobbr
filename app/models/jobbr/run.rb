module Jobbr

  class Run

    include Mongoid::Document
    include Mongoid::Timestamps

    field :status,      type: Symbol
    field :started_at,  type: Time
    field :finished_at, type: Time
    field :progress,    type: Integer, default: 0
    field :result

    belongs_to   :job
    embeds_many  :log_messages, class_name: 'Jobbr::LogMessage'

    index(job_id: 1)
    index(job_id: 1, started_at: -1)

    scope :for_job, ->(job) { Jobbr::Run.where(job_id: job.id).order_by(started_at: -1) }

    default_scope -> { without(:log_messages)}

    def run_time
      @run_time ||= if finished_at && started_at
        finished_at - started_at
      else
        nil
      end
    end

    def next
      return nil if index == 0
      @next ||= Run.for_job(job).all[index - 1]
    end

    def previous
      @previous ||= Run.for_job(job).all[index + 1]
    end

    def messages(limit = 1000)
      limit = [log_messages.length, limit].min
      log_messages[-limit..-1]
    end

    def result=(result)
      write_attribute(:result, result)
      save!
    end

    def progress=(progress)
      write_attribute(:progress, progress)
      save!
    end

    protected

    def index
      @index ||= job.runs.index(self)
    end

  end

end