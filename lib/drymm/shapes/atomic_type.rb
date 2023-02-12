# frozen_string_literal: true

module Drymm
  module Shapes
    # @api private
    class AtomicType < Concurrent::AtomicReference
      include Dry::Types::Type
      include Dry::Types::Builder
      include Dry::Types::Decorator
      include Dry::Equalizer(:type, inspect: false, immutable: false)

      def initialize(initial_type = Drymm::Undefined)
        Drymm::Undefined.map(initial_type) do
          set(initial_type)
        end
      end

      alias type get

      def to_s
        Dry::Types::PRINTER.(get) { get.to_s }
      end

      alias inspect to_s

      def respond_to_missing?(method_name, include_private = true)
        get.respond_to?(method_name, include_private) || super
      end

      def method_missing(method_name, *args, **opts, &blk)
        value = get

        if value.respond_to?(method_name, true)
          value.send(method_name, *args, **opts, &blk)
        else
          super
        end
      end
    end
  end
end
