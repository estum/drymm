# frozen_string_literal: true

module Drymm::S
  module Logic
    # Abstract struct class for nodes of {Dry::Logic}
    class Rule < Node
      abstract
      extend NodesBranch
    end

    # Unary nodes have the one {#rule} attribute.
    module Unary
      private_class_method def self.included(base)
        base.attribute :rule, Drymm['types.sum_rules']
      end

      # @!attribute rule [r]
      #   @return [Rule]
    end

    # Binary nodes have a pair of rules —
    # they are declared as {#left} and {#right}.
    module Binary
      private_class_method def self.included(base)
        base.attributes left: Drymm['types.sum_rules'], right: Drymm['types.sum_rules']
      end

      # @!attribute left [r]
      #   @return [Rule]

      # @!attribute right [r]
      #   @return [Rule]
    end

    # Grouping nodes have variadic amount of rules — so there is a {#rules} attribute
    module Grouping
      private_class_method def self.included(base)
        base.attributes rules: Drymm['types.rules']
      end

      # @!attribute rules [r]
      #   @return [Array<Rule>]
    end

    class Predicate < Rule
      attributes name: Drymm['types.symbol'], args: Drymm['types.ary_wrap_any']
    end

    class Attr < Rule
      attributes path: Drymm['types.symbol']
      include Unary
    end

    class Key < Rule
      attributes path: Drymm['types.any']
      include Unary
    end

    class Check < Rule
      attributes keys: Drymm['types.ary_wrap_any']
      include Unary
    end

    class Each < Rule
      include Unary
    end

    class Negation < Rule
      include Unary
    end

    class Not < Rule
      include Unary
    end

    class And < Rule
      include Binary
    end

    class Or < Rule
      include Binary
    end

    class Xor < Rule
      include Binary
    end

    class Implication < Rule
      include Binary
    end

    class Set < Rule
      include Grouping
    end
  end
end