# frozen_string_literal: true

require 'json'

module Drymm
  module Coder
    module Interface
      # @group Load / input methods

      def load(input)
        deserialize(parse(input))
      end

      def parse(input)
        ::JSON.parse(input, symbolize_names: true)
      end

      def deserialize(input)
        compile(hash_to_ast(**input))
      end

      def compile(input)
        @compiler.(input)
      end

      # @groupend

      # @group Dump / output method

      def dump(output)
        generate(serialize(output))
      end

      def serialize(output)
        ast_to_hash(output.to_ast)
      end

      def generate(output)
        ::JSON.fast_generate(output)
      end

      # @groupend
    end
  end
end
