# frozen_string_literal: true

module Drymm::Shapes
  module Types
    extend SumEnclosure

    # Abstract node branch class for shapes of {Dry::Types}
    class Type < Node
      abstract
      extend Branch

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
        self.class.compiler.(to_ast)
      end
    end

    self.sum = Type

    class Any < Type
      tuple_right false
      attribute :type, type_identifier
      attribute :meta, Drymm['types.meta']
    end

    class Array < Type
      attribute :type, type_identifier
      attribute :member, Drymm['types.sum.types']
      attribute :meta, Drymm['types.meta']
    end

    class CoercibleArray < Type
      attribute :type, type_enum(:json_array, :params_array)
      attribute :member, Drymm['types.sum.types']
    end

    class CoercibleHash < Type
      attribute :type, type_enum(:json_hash, :params_hash)
      attribute :keys, Drymm['types.variadic.types']
      attribute :meta, Drymm['types.meta']
    end

    class Composition < Type
      attribute :type, type_enum(:implication, :intersection, :transition, :sum)
      attribute :left, Drymm['types.sum.types']
      attribute :right, Drymm['types.sum.types']
      attribute :meta, Drymm['types.meta']
    end

    class Constrained < Type
      attribute :type, type_identifier
      attribute :base, Drymm['types.sum.types']
      attribute :rule, Drymm['types.sum.rules']
    end

    class Constructor < Type
      attribute :type, type_identifier
      attribute :base, Drymm['types.sum.types']
      attribute :fn, Drymm['types.fn']
    end

    class Enum < Type
      attribute :type, type_identifier
      attribute :base, Drymm['types.sum.types']
      attribute :mapping, Drymm['types.hash']
    end

    class Hash < Type
      attribute :type, type_identifier
      attribute :options, Drymm['types.opts']
      attribute :meta, Drymm['types.meta']
    end

    class Key < Type
      attribute :type, type_identifier
      attribute :name, Drymm['types.any']
      attribute :required, Drymm['types.bool']
      attribute :base, Drymm['types.sum.types']
    end

    class Lax < Type
      tuple_right false
      attribute :type, type_identifier
      attribute :base, Drymm['types.sum.types']

      def self.coerce_tuple((type, base))
        { type: type, base: base }
      end
    end

    class Map < Type
      attribute :type, type_identifier
      attribute :key_type, Drymm['types.sum.types']
      attribute :value_type, Drymm['types.sum.types']
      attribute :meta, Drymm['types.meta']
    end

    class Nominal < Type
      attribute :type, type_identifier
      attribute :base, Drymm['types.const']
      attribute :meta, Drymm['types.meta']
    end

    class Schema < Type
      attribute :type, type_identifier
      attribute :keys, Drymm['types.variadic.types']
      attribute :options, Drymm['types.opts']
      attribute :meta, Drymm['types.meta']
    end

    self.sum = Any | Array | CoercibleArray | CoercibleHash | Composition | Constrained | Constructor | Enum | Hash | Key | Lax | Map | Nominal | Schema
  end
end
