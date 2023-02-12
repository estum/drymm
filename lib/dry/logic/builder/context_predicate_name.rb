# frozen_string_literal: true

module Dry
  module Logic
    module Builder
      # @api private
      class Context
        # Defines custom predicate
        #
        # @name [Symbol] Name of predicate
        # @Context [Proc]
        def predicate(name, context = nil, &block)
          singleton_class.undef_method(name) if singleton_class.method_defined?(name)

          predicate = Rule::Predicate.new(context || block)

          define_singleton_method(name) do |*args|
            predicate.curry(*args)
          end
        end

        # Defines methods for operations and predicates
        def initialize
          Operations.constants(false).each do |name|
            next if Dry::Logic::Builder::IGNORED_OPERATIONS.include?(name)

            operation = Operations.const_get(name)

            define_singleton_method(name.downcase) do |*args, **kwargs, &block|
              operation.new(*call(&block), *args, **kwargs)
            end
          end

          Predicates::Methods.instance_methods(false).each do |name|
            predicate(name, Predicates[name]) unless Dry::Logic::Builder::IGNORED_PREDICATES.include?(name)
          end
        end
      end
    end
  end
end
