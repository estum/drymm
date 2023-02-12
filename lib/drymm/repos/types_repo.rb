# frozen_string_literal: true

module Drymm
  # @api private
  module TypesRepo
    extend Container

    register :any, Dry::Types["any"]

    register :ary, Dry::Types["array"]

    register :bool, Dry::Types["bool"]

    register :hash, Dry::Types["hash"]

    register :opts, (Dry::Types["hash"].default { Drymm::EMPTY_OPTS })
    alias_item :meta, :opts

    register :sym, Dry::Types["coercible.symbol"]

    register :str, Dry::Types["coercible.string"]

    T = method def self.t(member)
          return member if !member.is_a?(String) && !member.is_a?(Symbol)

          resolve(member) { member }
        end

    Array = method def self.array(member)
              t(:ary_wrap).of t(member)
            end

    Tuple = method def self.tuple(*members)
              Dry::Types::Tuple.build_unsplat(members)
            end

    Constrained = method def self.constrained(member, rule)
                    Dry::Types::Constrained.new(t(member), rule: rule)
                  end

    register "sum.types", proc { Shapes::Types.sum }, memoize: false

    register "sum.rules", proc { Shapes::Logic.sum }, memoize: false

    register "variadic.any", proc { Array[:any] }, memoize: true

    register "variadic.types", proc { Array["sum.types"] }, memoize: false

    register "variadic.rules", proc { Array["sum.rules"] }, memoize: false

    register :fn, proc { Shapes::Fn.sum }, memoize: false

    register :const, proc { Shapes::Const }, memoize: false
    alias_item :class, :const

    register :ast, proc { constrained(:any, Drymm["rules.as_ast"]) }, memoize: true

    register :ary_wrap, proc { T[:ary] << Drymm["fn.ary_wrap"] }, memoize: true
  end
end
