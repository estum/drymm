# frozen_string_literal: true

module Drymm::Shapes
  module Logic
    extend SumEnclosure

    # Abstract node branch class for shapes of {Dry::Logic}
    class Rule < Node
      abstract
      extend Branch

      # @return [::Dry::Logic::Predicates]
      def self.compiler_registry
        ::Dry::Logic::Predicates
      end

      # @return [::Dry::Logic::RuleCompiler]
      def self.compiler(registry = compiler_registry())
        ::Dry::Logic::RuleCompiler.new(registry)
      end
    end

    self.sum = Rule

    # Unary nodes have the one {#rule} attribute.
    module Unary
      private_class_method def self.included(base)
        base.attribute :rule, Drymm['types.sum.rules']
      end

      # @!attribute rule [r]
      #   @return [Rule]
    end

    # Binary nodes have a pair of rules —
    # they are declared as {#left} and {#right}.
    module Binary
      private_class_method def self.included(base)
        base.attributes left: Drymm['types.sum.rules'], right: Drymm['types.sum.rules']
      end

      # @!attribute left [r]
      #   @return [Rule]

      # @!attribute right [r]
      #   @return [Rule]
    end

    # Grouping nodes have variadic amount of rules — so there is a {#rules} attribute
    module Grouping
      private_class_method def self.included(base)
        base.tuple_right false
        base.attribute :rules, Drymm['types.variadic.rules']
        base.extend ClassMethods
      end

      module ClassMethods
        def coerce_tuple((type, *input))
          _, *keys = keys_order
          { type: type, **keys.zip(input).to_h }
        end
      end

      def to_ast
        [type, rules.map(&:to_ast) ]
      end

      # @!attribute rules [r]
      #   @return [Array<Rule>]
    end

    class Predicate < Rule
      attribute :name, Drymm['types.sym']
      attribute :args, Drymm['types.variadic.any']
    end

    class Attr < Rule
      attributes path: Drymm['types.sym']
      include Unary
    end

    class Key < Rule
      attributes path: Drymm['types.any']
      include Unary
    end

    class Check < Rule
      attributes keys: Drymm['types.variadic.any']
      include Unary
    end

    class Each < Rule
      include Unary
      tuple_right false
      retuple

      def self.coerce_tuple((type, rule))
        { type: type, rule: rule }
      end
    end

    class Negation < Rule
      include Unary
    end

    class Not < Rule
      attribute :rule, Drymm['types.sum.rules']
      tuple_right false
      retuple

      def self.coerce_tuple((type, rule))
        { type: type, rule: rule }
      end
    end

    class And < Rule
      include Grouping
    end

    class Or < Rule
      include Grouping
    end

    class Xor < Rule
      include Grouping
    end

    class Implication < Rule
      include Binary
    end

    class Set < Rule
      include Grouping
    end

    self.sum = Predicate | Attr | Key | Check | Each | Negation | Not | And | Or | Xor | Implication | Set
  end
end