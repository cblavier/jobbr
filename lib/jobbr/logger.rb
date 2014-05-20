module Jobbr

  class Logger

    attr_accessor :run, :wrapped_logger, :level

    def initialize(logger, run)
      self.wrapped_logger = logger
      self.run = run
      self.level = 0
    end

    def debug(message)
      wrapped_logger.debug(message)
      write_message(:debug, message)
    end

    def info(message)
      wrapped_logger.info(message)
      write_message(:info, message)
    end

    def warn(message)
      wrapped_logger.warn(message)
      write_message(:warn, message)
    end

    def error(message)
      wrapped_logger.error(message)
      write_message(:error, message)
    end

    def fatal(message)
      wrapped_logger.error(message)
      write_message(:fatal, message)
    end

    protected

    def write_message(kind, message)
      if message.is_a? Array
        message = message.join('<br/>')
      end
      Jobbr::LogMessage.create(kind: kind, message: message, run: run)
    end

  end

end
