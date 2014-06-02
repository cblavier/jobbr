require 'active_support/concern'
require 'sidekiq/delay'

module Jobbr

  module Delayed

    extend ActiveSupport::Concern

    included do

      include Sidekiq::Delay

    end

  end

end
