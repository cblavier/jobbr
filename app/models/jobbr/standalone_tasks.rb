module Jobbr
  module StandaloneTasks

    # Build the information about the crontab jobs which
    # will used to generate the corresponding rake tasks.
    # If a block is passed, then it will iterate over each information.
    #
    # @params [ String ] name Name of the kind of jobs (scheduled_job)
    #
    def self.all(name, &block)
      self.mock_job
      require File.join(File.dirname(__FILE__), "#{name}.rb")

      dependencies = ['Jobbr::Job', "Jobbr::#{name.to_s.camelize}"]

      # load all the classes for the specific kind
      list = Dir[Rails.root.join('app', 'models', name.to_s.pluralize, '*.rb')].map do |file|
        require file
        klass = "#{name.to_s.pluralize.camelize}::#{File.basename(file, '.rb').camelize}".constantize
        dependencies << klass.name
        {
          name:             klass.task_name.to_sym,
          desc:             klass.description,
          klass_name:       klass.name,
          heroku_frequency: klass.heroku_frequency,
          heroku_priority:  klass.heroku_priority,
          dependencies: (dependencies[0..1] + [klass.name]).map { |n| "#{n.underscore}.rb" }
        }
      end

      # clean our Job mock and make sure to unload its children as well
      dependencies.reverse.each do |name|
        module_name, klass_name = name.split('::')
        module_name.constantize.send(:remove_const, klass_name.to_sym)
      end

      list.each(&block)
    end

    protected

    # Mock Jobbr::Job which avoids to load the Mongoid stack
    #
    def self.mock_job
      c = Class.new do
        def self.field(*args); end
        def self.default_scope(*args); end
        def self.description(desc = nil)
          @description = desc if desc
          @description
        end
      end

      ::Jobbr.const_set 'Job', c
    end

  end
end