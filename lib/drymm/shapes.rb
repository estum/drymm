# frozen_string_literal: true

module Drymm
  module Shapes
    include Constants

    class << self
      def sum
        Drymm['sum']
      end

      def call(input)
        sum.call(input)
      end

      alias_method :[], :call
    end

    # @api private
    module Mix
      private def included(base)
        base.extend(const_get(:ClassMethods))
      end
    end

  end
end
