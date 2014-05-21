module Jobbr

  module Ohm

    extend self

    require "ohm"

    # Return all Ohm models.
    # You can also pass a module class to get all models including that module
    def models(parent = nil)
      model_paths = Dir["#{Rails.root}/app/models/**/*.rb"]
      model_paths.each{ |path| require path }
      sanitized_model_paths = model_paths.map { |path| path.gsub(/.*\/app\/models\//, '').gsub('.rb', '') }
      model_constants = sanitized_model_paths.map do |path|
        path.split('/').map { |token| token.camelize }.join('::').constantize
      end
      model_constants.select { |model| superclasses(model).include?(::Ohm::Model) }

      if parent
        model_constants.select { |model| model.included_modules.include?(parent) }
      else
        model_constants
      end
    end

    # Return i list of classes (will not require all model dependencies)
    def model_descriptions(model_kind)
      return unless block_given?
      mock_job

      dependencies = ['Jobbr::Job']

      # load all the classes for the specific kind
      list = Dir[Rails.root.join('app', 'models', model_kind.to_s.pluralize, '*.rb')].map do |file|
        require file
        klass = "#{model_kind.to_s.pluralize.camelize}::#{File.basename(file, '.rb').camelize}".constantize
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

      list.each do |description|
        yield(description)
      end

      # clean our Job mock and make sure to unload its children as well
      dependencies.reverse.each do |name|
        module_name, klass_name = name.split('::')
        module_name.constantize.send(:remove_const, klass_name.to_sym)
      end

    end

    protected

    # Return all superclasses for a given class.
    def superclasses(klass)
      super_classes = []
      while klass != Object
        klass = klass.superclass
        super_classes << klass
      end
      super_classes
    end

    # Mock Jobbr::Job which avoids to load the Mongoid stack
    def mock_job
      c = Class.new do
        def self.field(*args); end
        def self.default_scope(*args); end
        def self.description(desc = nil)
          @description = desc if desc
          @description
        end
      end
      ::Jobbr.send(:remove_const, :Job)
      ::Jobbr.const_set 'Job', c
    end

  end

end
