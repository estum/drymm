# frozen_string_literal: true

module Drymm
  module Shapes
    # # Shapes namespace for Dry::Types
    module Types
      extend SumEnclosure

      # @abstract
      #   Abstract node branch class for shapes of {Dry::Types}
      class Type < Node
        abstract
        extend Branch
        extend Summarize

        def self.namespace
          Types
        end

        # @return [::Dry::Logic::Predicates]
        def self.compiler_registry
          ::Dry::Types
        end

        # @return [::Dry::Logic::RuleCompiler]
        def self.compiler(registry = compiler_registry())
          ::Dry::Types::Compiler.new(registry)
        end

        def compile
          self.class.compiler.call(to_ast)
        end
      end

      sum.set Type

      # @see Dry::Types::Any
      class Any < Type
        tuple_right false
        attribute :type, type_identifier
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Array
      class Array < Type
        attribute :type, type_identifier
        attribute :member, Drymm["types.sum.types"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::JSON
      # @see Dry::Types::Params
      class CoercibleArray < Type
        attribute :type, type_enum(:json_array, :params_array)
        attribute :member, Drymm["types.sum.types"]
      end

      # @see Dry::Types::JSON
      # @see Dry::Types::Params
      class CoercibleHash < Type
        attribute :type, type_enum(:json_hash, :params_hash)
        attribute :keys, Drymm["types.variadic.types"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Composition
      class Composition < Type
        attribute :type, type_enum(:implication, :intersection, :transition, :sum)
        attribute :left, Drymm["types.sum.types"]
        attribute :right, Drymm["types.sum.types"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Constrained
      class Constrained < Type
        attribute :type, type_identifier
        attribute :base, Drymm["types.sum.types"]
        attribute :rule, Drymm["types.sum.rules"]
      end

      # @see Dry::Types::Constructor
      class Constructor < Type
        attribute :type, type_identifier
        attribute :base, Drymm["types.sum.types"]
        attribute :fn, Drymm["types.fn"]
      end

      # @see Dry::Types::Enum
      class Enum < Type
        attribute :type, type_identifier
        attribute :base, Drymm["types.sum.types"]
        attribute :mapping, Drymm["types.hash"]
      end

      # @see Dry::Types::Hash
      class Hash < Type
        attribute :type, type_identifier
        attribute :options, Drymm["types.opts"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Schema::Key
      class Key < Type
        attribute :type, type_identifier
        attribute :name, Drymm["types.any"]
        attribute :required, Drymm["types.bool"]
        attribute :base, Drymm["types.sum.types"]
      end

      # @see Dry::Types::Lax
      class Lax < Type
        tuple_right false
        attribute :type, type_identifier
        attribute :base, Drymm["types.sum.types"]

        def self.coerce_tuple((type, base))
          { type: type, base: base }
        end
      end

      # @see Dry::Types::Map
      class Map < Type
        attribute :type, type_identifier
        attribute :key_type, Drymm["types.sum.types"]
        attribute :value_type, Drymm["types.sum.types"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Nominal
      class Nominal < Type
        attribute :type, type_identifier
        attribute :base, Drymm["types.const"]
        attribute :meta, Drymm["types.meta"]
      end

      # @see Dry::Types::Schema
      class Schema < Type
        attribute :type, type_identifier
        attribute :keys, Drymm["types.variadic.types"]
        attribute :options, Drymm["types.opts"]
        attribute :meta, Drymm["types.meta"]
      end
    end
  end
end
