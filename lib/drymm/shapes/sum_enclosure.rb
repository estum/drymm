# frozen_string_literal: true

module Drymm
  module Shapes
    # @api private
    module SumEnclosure
      include Dry::Types::Type
      include Dry::Types::Meta

      # @api private
      def sum
        @sum ||= AtomicType.new
      end

      # @!method call(input, &block)
      #   @overload call(type: :id, id:)
      #     @param id [Symbol, String]
      #   @overload call(type: :callable, callable:)
      #     @param callable [#call]
      #   @overload call(type: :method, target:, name:)
      #     @param target [#(name)] namespace
      #     @param name [Symbol, String]
      #   @return [self]

      # @api private
      def call_unsafe(input)
        @sum.call(input)
      end

      # @api private
      def call_safe(input, &block)
        @sum.call(input, &block)
      end

      # @api private
      def try(input, &block)
        @sum.try(input, &block)
      end
    end
  end
end
