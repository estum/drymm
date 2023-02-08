# frozen_string_literal: true

module Drymm::S
  class Fn < Node
    attribute :type, Drymm['types.fn.type']
    attribute :node, Drymm['types.fn.node']

    tuple Drymm['types.fn.tuple']

    def self.coerce_tuple(input)
      input = input.dup
      type = input.shift
      node = input
      { type: type, node: node }
    end
  end
end
