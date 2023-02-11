# frozen_string_literal: true

module Drymm
  module RulesRepo
    extend Dry::Container::Mixin

    register :const,
      proc { key(name: 0) { case?(Drymm['types.const']) } },
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
