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

    class Predicate < Rule
      attribute :type, type_identifier
      attribute :name, Drymm['types.sym']
      attribute :args, Drymm['types.variadic.any']
    end

    class Check < Rule
      attribute :type, type_identifier
      attribute :keys, Drymm['types.variadic.any']
      attribute :rule, Drymm['types.sum.rules']
    end

    class Unary < Rule
      tuple_right false
      attribute :type, type_enum(:each, :not, :negation)
      attribute :rule, Drymm['types.sum.rules']

      def self.coerce_tuple((type, rule))
        { type: type, rule: rule }
      end
    end

    class RoutedUnary < Rule
      attribute :type, type_enum(:attr, :key)
      attribute :path, Drymm['types.any']
      attribute :rule, Drymm['types.sum.rules']
    end

    class Grouping < Rule
      tuple_right false
      attribute :type, type_enum(:and, :or, :xor, :set)
      attribute :rules, Drymm['types.variadic.rules']

      def to_ast
        [type, rules.map(&:to_ast)]
      end

      def self.coerce_tuple((type, rules))
        { type: type, rules: rules }
      end
    end

    class BinaryComposition < Rule
      attribute :type, type_enum(:implication, :transition)
      attribute :left, Drymm['types.sum.rules']
      attribute :right, Drymm['types.sum.rules']
    end

    self.sum = Predicate | Unary | RoutedUnary | Check | Grouping | BinaryComposition
  end
end