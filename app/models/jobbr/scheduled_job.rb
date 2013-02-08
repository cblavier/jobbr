module Jobbr

  class ScheduledJob < Job

    field :scheduled, type: Boolean, default: true

    default_scope ->{ Job.where(scheduled: true, :_type.ne => nil) }

    def perform
      raise NotImplementedError.new :message => 'Must be implemented'
    end

    def self.every(every = nil, options = {})
      @every = [every, options] if every
      @every
    end

    def self.task_name(with_namespace = false)
      task_name = name.demodulize.underscore
      if with_namespace
        "jobbr:#{task_name}"
      else
        task_name
      end
    end

  end

end