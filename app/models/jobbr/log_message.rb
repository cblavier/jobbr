module Jobbr

  class LogMessage

    include Mongoid::Document

    field :message,  type: String
    field :kind,     type: Symbol
    field :date,     type: Time

    embedded_in :run

  end

end