# frozen_string_literal: true

module Dry
  module Types
    module Builder
      # Compose two types into an Transition type
      #
      # @param [Type] right
      #   right type, resulting
      #
      # @return [Transition, Transition::Constrained]
      #
      # @api public
      def >=(right)
        compose(right, Transition)
      end

      # Compose two types into an Transition type
      #
      # @param [Type] left
      #   left type, transitive
      #
      # @return [Transition, Transition::Constrained]
      #
      # @api public
      def <=(left)
        left >= self
      end
    end

    class Compiler
      def visit_transition(node)
        *types, meta = node
        types.map { |type| visit(type) }.reduce(:>=).meta(meta)
      end
    end

    # @api public
    class Transition
      include Composition

      def self.operator
        :>=
      end

      # @param [Object] input
      #
      # @return [Object]
      #
      # @api private
      def call_unsafe(input)
        left_result = left.try(input)
        if left_result.success?
          right.call_unsafe(left_result.input)
        else
          left_result.input
        end
      end

      # @param [Object] input
      #
      # @return [Object]
      #
      # @api private
      def call_safe(input, &block)
        left_result = left.try(input)
        if left_result.success?
          right.call_safe(left_result.input, &block)
        else
          left_result.input
        end
      end

      # @param [Object] input
      #
      # @api public
      def try(input)
        left_result = left.try(input)

        if left_result.success?
          right.try(left_result.input)
        else
          left_result
        end
      end

      # @param [Object] value
      #
      # @return [Boolean]
      #
      # @api private
      def primitive?(value)
        if left.primitive?(value)
          right.primitive?(value)
        else
          true
        end
      end
    end

    class Printer
      MAPPING[Transition] = :visit_composition
      MAPPING[Transition::Constrained] = :visit_composition
    end
  end
end