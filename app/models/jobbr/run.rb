module Jobbr

  class Run < ::Ohm::Model

    include ::Ohm::Timestamps
    include ::Ohm::DataTypes

    attribute :status,      Type::Symbol
    attribute :started_at,  Type::Time
    attribute :finished_at, Type::Time
    attribute :progress,    Type::Integer
    attribute :result

    reference  :job,      'Jobbr::Job'
    collection :messages, 'Jobbr::LogMessage'

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

    protected

    def index
      @index ||= job.runs.index(self)
    end

  end

end
