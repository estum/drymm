# frozen_string_literal: true

module Drymm::Shapes
  module Types
    ##
    # @group Mixins

    module Meta
      private_class_method def self.included(base)
        base.attribute :meta, Drymm['types.meta']
      rescue
      end

      # @!attribute meta [r]
      #   @return [Hash]
    end

    module Opts
      private_class_method def self.included(base)
        base.attribute :options, Drymm['types.opts']
      end

      # @!attribute options [r]
      #   @return [Hash]
    end

    module Complex
      private_class_method def self.included(base)
        base.attribute :nominal, Drymm['types.sum.types']
      end

      # @!attribute nominal [r]
      #   @return [Types.sum]
    end

    module Keys
      private_class_method def self.included(base)
        base.attribute :keys, Drymm['types.variadic.types']
      end

      # @!attribute keys [r]
      #   @return [Array(Any)]
    end

    module Binary
      private_class_method def self.included(base)
        sum_types = Drymm['types.sum.types']
        base.attributes left: sum_types, right: sum_types
      end

      # @!attribute left [r]
      #   @return [Types.sum]

      # @!attribute right [r]
      #   @return [Types.sum]
    end

    # @endgroup
    ##

    ##
    # @group Classes

    # Abstract node branch class for shapes of {Dry::Types}
    class Type < Node
      abstract
      extend Branch
    end

    class Any < Type
      include Meta
    end

    class Nominal < Type
      attribute :type_class, Drymm['types.const']
      include Meta
    end

    class Constrained < Type
      [Complex, Logic::Unary].each &method(:include)
    end

    class Constructor < Type
      include Complex
      attribute :fn, Drymm['types.fn']
    end

    class Lax < Type
      attribute :node, Drymm['types.sum.types']
    end

    class Sum < Type
      [Binary, Meta].each &method(:include)
    end

    class Array < Type
      attribute :member, Drymm['types.member']
      include Meta
    end

    class Hash < Type
      [Opts, Meta].each &method(:include)
    end

    class Schema < Type
      [Keys, Opts, Meta].each &method(:include)
    end

    class JSONHash < Type
      [Keys, Meta].each &method(:include)
    end

    class ParamsHash < Type
      [Keys, Meta].each &method(:include)
    end

    class JSONArray < Type
      attribute :member, Drymm['types.sum.types']
    end

    class ParamsArray < Type
      attribute :member, Drymm['types.sum.types']
    end

    class Key < Type
      attributes name: Drymm['types.any'], required: Drymm['types.bool'], node: Drymm['types.sum.types']
    end

    class Enum < Type
      attributes node: Drymm['types.sum.types'], mapping: Drymm['types.hash']
    end

    class Map < Type
      attributes key_type: Drymm['types.sum.types'], value_type: Drymm['types.sum.types']
      include Meta
    end

    # @endgroup
    ##
  end
end
