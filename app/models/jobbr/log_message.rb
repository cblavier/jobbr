module Jobbr

  class LogMessage < ::Ohm::Model

    include ::Ohm::Timestamps
    include ::Ohm::DataTypes

    attribute :kind,    Type::Symbol
    attribute :date,    Type::Time
    attribute :message

    reference  :run, 'Jobbr::Run'

  end

end
