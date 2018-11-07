require 'active_support/concern'

module Jobbr

  module Delayed

    extend ActiveSupport::Concern

    module ClassMethods

      def queue(queue = nil)
        @queue = queue.to_sym if queue
        @queue
      end

      def throttle(options = nil)
        @throttle_options = options if options
        @throttle_options
      end

    end

  end

end
