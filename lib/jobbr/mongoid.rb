module Jobbr

  module Mongoid

    include ::Mongoid

    extend self

    # Return all Mongoid models.
    # You can also pass a parent class to get all Mongoid childrens
    #
    # @example Return *all* models.
    #   Rails::Mongoid.models
    #
    # @example Return Job children models.
    #   Rails::Mongoid.models(Job)
    #
    # @param [ Class ] parent The parent model class.
    #
    # @return [ Array<Class> ] The models.
    #
    def models(parent = nil)
      model_paths = Dir["#{Rails.root}/app/models/**/*.rb"]
      sanitized_model_paths = model_paths.map { |path| path.gsub(/.*\/app\/models\//, '').gsub('.rb', '') }
      model_constants = sanitized_model_paths.map do |path|
        path.split('/').map { |token| token.camelize }.join('::').constantize
      end
      model_constants = model_constants.select { |constant| constant.include?(Mongoid::Document) }

      if parent
        model_constants.select { |model| superclasses(model).include?(parent) }
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