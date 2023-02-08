module Drymm::S
  # [✓] nominal:      %i[_type meta],
  # [✓] constrained:  %i[nominal rule],
  # [✓] constructor:  %i[nominal fn],
  # [✓] any:          %i[meta]
  # [✓] lax:          %i[node],
  # [✓] sum:          %i[left right meta],
  # [ ] array:        %i[member meta],
  # [ ] const:        %i[cname],
  # [ ] hash:         %i[opts meta],
  # [ ] schema:       %i[keys options meta],
  # [ ] json_hash:    %i[keys meta],
  # [ ] json_array:   %i[member meta],
  # [ ] params_hash:  %i[keys meta],
  # [ ] params_array: %i[member meta],
  # [ ] key:          %i[name required _type],
  # [ ] enum:         %i[_type mapping],
  # [ ] map:          %i[key_type value_type meta],

  module Types
    ##
    # @group Mixins

    module Meta
      def self.included(base)
        base.attribute :meta, Drymm['types.meta']
      rescue
      end
    end

    module Opts
      def self.included(base)
        base.attribute :options, Drymm['types.options']
      end
    end

    module Complex
      def self.included(base)
        base.attribute :nominal, Drymm['types.sum_types']
      end
    end

    module Keys
      def self.included(base)
        base.attribute :keys, Drymm['types.types']
      end
    end

    module Binary
      def self.included(base)
        sum_types = Drymm['types.sum_types']
        base.attributes left: sum_types, right: sum_types
      end
    end

    # @endgroup
    ##

    ##
    # @group Classes

    # Abstract struct class for nodes of {Dry::Types}
    class Type < Node
      abstract
      extend NodesBranch
    end

    class Any < Type
      include Meta
    end

    class Nominal < Type
      attribute :type_class, Drymm['types.class']
      include Meta
    end

    class Constrained < Type
      include Complex
      include Logic::Unary
    end

    class Constructor < Type
      include Complex
      attribute :fn, Drymm['types.fn']
    end

    class Lax < Type
      attribute :node, Drymm['types.sum_types']
    end

    class Sum < Type
      include Binary
      include Meta
      tuple Dry::Types::Tuple.build(
        type_identifier,
        Dry::Types::Tuple.build(
          Drymm['types.sum_types'],
          Drymm['types.sum_types'],
          Drymm['types.meta']
        )
      )
    end

    class Array < Type
      attribute :member, Drymm['types.member']
      include Meta
    end

    class Hash < Type
      include Opts, Meta
    end

    class Schema < Type
      include Keys, Opts, Meta
    end

    class JSONHash < Type
      include Keys, Meta
    end

    class ParamsHash < Type
      include Keys, Meta
    end

    class JSONArray < Type
      attribute :member, Drymm['types.sum_types']
    end

    class ParamsArray < Type
      attribute :member, Drymm['types.sum_types']
    end

    class Key < Type
      attributes name:     Drymm['types.any'],
                 required: Drymm['types.bool'],
                 node:     Drymm['types.sum_types']
    end

    class Enum < Type
      attributes node: Drymm['types.sum_types'],
                 mapping: Drymm['types.hash']
    end

    class Map < Type
      attributes key_type: Drymm['types.sum_types'],
                 value_type: Drymm['types.sum_types']
      include Meta
    end

    # @endgroup
    ##
  end
end
