# frozen_string_literal: true

module Drymm
  module Shapes
    # {Drymm::Shapes}'s class interface mixin, designed to extend
    # an abstract __subclass__ of {Drymm::Shapes::Node}, creating a kind of
    # Shape's branch or, in other words, derivative, to enclose specific namespace.
    module Branch
      # @api private
      # Defines {sum} class attribute when extended.
      private_class_method def self.extended(base)
        base.defines :tuple_right
        base.tuple_right true
        base.private_class_method :auto_tuple
      end

      # @api private
      # Flattens the 1st level of the input array.
      def coerce_tuple(input)
        super(input.flatten(1))
      end

      # @api private
      def auto_tuple(*keys)
        keys_order(keys_order | keys)
        index = schema.keys.map { |t| [t.name, t.type] }.to_h
        key_type, *node_types = index.values_at(*keys_order)
        if tuple_right
          tuple Tuple(key_type, Tuple(*node_types))
        else
          tuple Tuple(key_type, *node_types)
        end
      end

      def retuple
        auto_tuple!(*keys_order)
      end

      def auto_tuple!(*keys)
        remove_instance_variable(:@keys_order) if instance_variable_defined?(:@keys_order)
        remove_instance_variable(:@tuple) if instance_variable_defined?(:@tuple)
        keys_order []
        auto_tuple(*keys)
      end

      private

      # Shorthand method to build a tuple
      # @return [Dry::Types::Tuple]
      def Tuple(*args)
        Drymm::TypesRepo.tuple(*args)
      end
    end
  end
end
