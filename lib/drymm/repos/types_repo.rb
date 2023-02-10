# frozen_string_literal: true

module Drymm
  module TypesRepo
    extend Container

    register :any, Dry::Types['any']

    register :ary, Dry::Types['array']

    register :bool, Dry::Types['bool']

    register :hash, Dry::Types['hash']

    register :opts, Dry::Types['hash'].default { Constants::EMPTY_OPTS }

    register :sym, Dry::Types['coercible.symbol']

    register :str, Dry::Types['coercible.string']

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

    register 'sum.types', proc { Shapes::Types::Type.descendants.reduce(:|) }, memoize: false

    register 'sum.rules', proc { Shapes::Logic::Rule.descendants.reduce(:|) }, memoize: false

    register 'variadic.any', proc { Array[:any] }, memoize: true

    register 'variadic.types', proc { Array['sum.types'].meta(rehash: 'types.variadic.types') }, memoize: false

    register 'variadic.rules', proc { Array['sum.rules'].meta(rehash: 'types.variadic.rules') }, memoize: false

    register :fn, proc { Shapes::Fn::Sum }, memoize: false

    register :const, proc { Shapes::Const }, memoize: false

    alias_item :meta, :opts

    alias_item :class, :const

    with_options memoize: true do |m|

      m.register :blank_hash, proc { T[:hash].constrained(size: 0) }

      m.register :wrapped_hash, proc { Array[:hash].constrained(size: 1) }

      m.register :ary_wrap, proc { T[:ary] << Drymm['fn.ary_wrap'] }

      m.register :ast_node, proc { constrained(:ary, Drymm['rules.node'])  }

      m.register :member, proc { T[:class] | T['sum.types'] }
    end
  end
end
