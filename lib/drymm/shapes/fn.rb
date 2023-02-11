# frozen_string_literal: true

module Drymm::Shapes
  # Namespace of function shapes, i.e. procs or methods, used by {Dry::Types}
  module Fn
    extend SumEnclosure

    class FnNode < Node
      attribute :type, type_enum(:id, :callable, :method)

      def self.namespace
        Fn
      end

      # @return [::Dry::Logic::Predicates]
      def self.compiler_registry
        ::Dry::Types.container
      end

      # @return [::Dry::Logic::RuleCompiler]
      def self.compiler(registry = compiler_registry())
        ::Dry::Types::Compiler.new(registry)
      end

      def compile
        self.class.compiler.compile_fn(to_ast)
      end
    end

    self.sum = FnNode

    # Represents functions, stored in {Dry::Types::FnContainer}
    class ID < FnNode
      attribute :type, type_identifier(:id)
      attribute :id, Drymm['types.str']
    end

    # Represent callable objects but not an internal procs
    class Callable < FnNode
      attribute :type, type_identifier(:callable)
      attribute :callable, Drymm['types.any']

      # @!attribute callable [r]
      #   @return [#call]
    end

    # Represents a method calls
    class Method < FnNode
      attribute :type, type_identifier(:method)
      attribute :target, Drymm['types.const'] | Drymm['types.any']
      attribute :name, Drymm['types.sym']

      def to_ast
        super.flatten(1)
      end
    end

    self.sum = ID | Callable | Method
  end
end
