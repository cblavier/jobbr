require 'active_support/concern'

module Jobbr

  module Delayed

    extend ActiveSupport::Concern

    included do

      include Sidekiq::Extensions::ActiveRecord

    end

  end

end
