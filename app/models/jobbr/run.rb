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

    index :status

    def run_time
      @run_time ||= if finished_at && started_at
        finished_at - started_at
      else
        nil
      end
    end

    def name
      job.type.demodulize.underscore.gsub(/_job$/, '')
    end

    def to_hash
      super.tap do |hash|
        %w(name status result progress).each do |key|
          hash[key.to_sym] = send(key.to_sym)
        end
      end
    end

    def to_param
      id
    end

    def ordered_messages
      self.messages.sort_by(:created_at, order: 'ALPHA ASC')
    end

    def before_delete
      self.messages.each(&:delete)
    end

    def logger
      @logger ||= Jobbr::Logger.new(Rails.logger, self)
    end

  end

end
