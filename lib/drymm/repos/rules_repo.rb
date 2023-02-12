# frozen_string_literal: true

module Drymm
  # @api private
  module RulesRepo
    extend Container

    register :const,
             proc { key(name: 0) { case?(Drymm["types.const"]) } },
             call: false

    register :ary,
             proc { array? },
             call: false

    register :node,
             proc { array? & min_size?(1) & key(name: 0) { negation { array? } } },
             call: false

    register :as_ast,
             proc { respond_to?(:to_ast) },
             call: false
  end
end
