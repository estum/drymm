# frozen_string_literal: true

require "json"

module Drymm
  module Shapes
    # JSON serialization methods mixin.
    module JSONMethods
      extend Mix

      # Dumps the instance to a JSON string.
      # @param pretty [Hash]
      # @return [String]
      def to_json(pretty: nil)
        if pretty
          JSON.pretty_generate(to_hash, pretty)
        else
          JSON.fast_generate(to_hash)
        end
      end

      # @api private
      module ClassMethods
        # Parse JSON to a shape node
        def from_json(payload)
          call(JSON.parse(payload, symbolize_names: true))
        end
      end
    end
  end
end
