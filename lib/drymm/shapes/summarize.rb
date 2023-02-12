# frozen_string_literal: true

module Drymm
  module Shapes
    # @api private
    module Summarize
      private

      # @api private
      def inherited(subclass)
        super
        namespace.sum.try_update! do |current|
          if current == abstract_class
            subclass
          else
            current | subclass
          end
        end
      end
    end
  end
end
