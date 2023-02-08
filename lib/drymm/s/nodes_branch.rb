# frozen_string_literal: true

module Drymm::S
  # Node's class interface module, should extend an abstract Node's __subclass__
  # to enclose specific namespace.
  module NodesBranch
    class << self
      # @api private
      # Defines {sum} class attribute when extended.
      private def extended(base)
        base.defines :sum
        base.private_class_method :auto_tuple
      end
    end

    # @!method sum(value)

    # @!attribute sum [r]
    #   @return [Dry::Types::Sum]

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
      tuple Dry::Types::Tuple.build(key_type, Dry::Types::Tuple.build(*node_types))
    end

    # @api private
    # Declares the `type` attribute entirely in each subclass
    # (because each subclass have its own node type identifier).
    # Also each subclass instantiation updates {.sum} class attribute.
    private def inherited(subclass)
      super

      subclass.attribute :type, subclass.type_identifier

      Dry::Monads.Maybe(sum()).
        fmap { |existing| existing | subclass }.
        or_fmap { subclass }.
        bind { |combination| sum(combination) }
    end
  end
end
