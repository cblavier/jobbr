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

    # Return all superclasses for a given class.
    #
    # @param [ Class ] parent The class you want to get superclasses from.
    #
    # @return [ Array<Class> ] The superclasses.
    #
    def superclasses(klass)
      super_classes = []
      while klass != Object
        klass = klass.superclass
        super_classes << klass
      end
      super_classes
    end

  end

end
