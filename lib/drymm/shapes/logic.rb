# frozen_string_literal: true

module Drymm
  module Shapes
    # # Shapes namespace for Dry::Logic
    module Logic
      extend SumEnclosure

      # @abstract
      #   Abstract node branch class for shapes of {Dry::Logic}
      class Rule < Node
        abstract
        extend Branch
        extend Summarize

        def self.namespace
          Logic
        end

        # @return [::Dry::Logic::Predicates]
        def self.compiler_registry
          ::Dry::Logic::Predicates
        end

        # @return [::Dry::Logic::RuleCompiler]
        def self.compiler(registry = compiler_registry())
          ::Dry::Logic::RuleCompiler.new(registry)
        end
      end

      sum.set Rule

      # @see Dry::Logic::Predicate::Rule
      class Predicate < Rule
        attribute :type, type_identifier
        attribute :name, Drymm["types.sym"]
        attribute :args, Drymm["types.variadic.any"]
      end

      # @see Dry::Logic::Operations::Check
      class Check < Rule
        attribute :type, type_identifier
        attribute :keys, Drymm["types.variadic.any"]
        attribute :rule, Drymm["types.sum.rules"]
      end

      # @see Dry::Logic::Operations::Unary
      class Unary < Rule
        tuple_right false
        attribute :type, type_enum(:each, :not, :negation)
        attribute :rule, Drymm["types.sum.rules"]

        def self.coerce_tuple((type, rule))
          { type: type, rule: rule }
        end
      end

      # @see Dry::Logic::Operations::Attr
      # @see Dry::Logic::Operations::Key
      class RoutedUnary < Rule
        attribute :type, type_enum(:attr, :key)
        attribute :path, Drymm["types.any"]
        attribute :rule, Drymm["types.sum.rules"]
      end

      # @see Dry::Logic::Operations::Binary
      class Grouping < Rule
        tuple_right false
        attribute :type, type_enum(:and, :or, :xor, :set)
        attribute :rules, Drymm["types.variadic.rules"]

        def to_ast
          [type, rules.map(&:to_ast)]
        end

        def self.coerce_tuple((type, rules))
          { type: type, rules: rules }
        end
      end

      # @see Dry::Logic::Operations::Implication
      class BinaryComposition < Rule
        attribute :type, type_enum(:implication)
        attribute :left, Drymm["types.sum.rules"]
        attribute :right, Drymm["types.sum.rules"]
      end
    end
  end
end
