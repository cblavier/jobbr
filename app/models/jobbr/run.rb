module Jobbr

  class Run < ::Ohm::Model

    include ::Ohm::Timestamps
    include ::Ohm::DataTypes
    include ::Ohm::Callbacks

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

    def to_param
      id
    end

    def ordered_messages
      self.messages.sort(by: :created_at, order: 'ASC')
    end

    def after_delete
      self.messages.each(&:delete)
    end

    def logger
      @logger ||= Jobbr::Logger.new(Rails.logger, self)
    end

  end

end
