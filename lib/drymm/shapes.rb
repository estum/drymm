# frozen_string_literal: true

module Drymm
  # The core Shapes namespace
  module Shapes
    include Dry::Core::Constants

    # @api private
    module Mix
      private

      def included(base)
        base.extend(const_get(:ClassMethods))
      end
    end

    class << self
      def sum
        Drymm["sum"]
      end

      def call(input)
        sum[input]
      end

      alias [] call
    end

    extend JSONMethods::ClassMethods
  end
end
