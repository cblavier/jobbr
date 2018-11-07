require 'active_support/concern'

module Jobbr

  module Scheduled

    extend ActiveSupport::Concern

    module ClassMethods

      def every(every = nil, options = {})
        @every = [every, options] if every
        @every
      end

      # heroku frequency can be :minutely, :hourly or :daily
      def heroku_run(frequency, options = {})
        @heroku_frequency = frequency
        @heroku_priority = options[:priority] || 0
      end

      def heroku_frequency
        @heroku_frequency
      end

      def heroku_priority
        @heroku_priority
      end

      def task_name
        name.demodulize.underscore
      end

      def delayed
        false
      end

    end

  end

end
