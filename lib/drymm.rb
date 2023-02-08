# frozen_string_literal: true

require_relative 'drymm/version'
require 'zeitwerk'
require 'dry/container'
require 'dry/logic/predicates'
require 'dry/logic/builder'
require 'dry/inflector'
require 'dry/struct'
require 'dry/types'
require 'dry/monads/all'
require 'dry/tuple'

require "singleton"
require "delegate"

# Load patches for dry-rb gems if need

require 'dry/types/printer/visit_sum_constructors' if !Dry::Types::Printer.method_defined?(:visit_sum_constructors)
require 'dry/types/transition' if !defined?(Dry::Types::Transitive)
require 'dry/logic/builder/context_predicate_name' if !Dry::Logic::Builder::Context.instance_method(:predicate).parameters.include?([:opt, :context])

module Drymm
  # @api private
  class Inflector < Dry::Inflector
    def initialize(root_file, &block)
      super(&block)
      namespace     = File.basename(root_file, ".rb")
      lib_dir       = File.dirname(root_file)
      @version_file = File.join(lib_dir, namespace, "version.rb")
    end

    def camelize(basename, abspath)
      abspath == @version_file ? "VERSION" : super(basename)
    end
  end

  # @api private
  def self.loader
    @loader ||= begin
      loader = Zeitwerk::Loader.for_gem
      loader.tag = 'drymm'
      loader.inflector = Inflector.new(__FILE__)
      loader.ignore("#{__dir__}/dry")
      loader
    end
  end

  loader.enable_reloading if $0 == 'bin/console'
  loader.setup

  extend Dry::Container::Mixin
  include Constants

  register 's.node.type_identifier' do |name|
    inflector = loader.inflector
    inflector.underscore(inflector.demodulize(name)).to_sym
  end

  module LogicWrapper
    def self.call(fn)
      Dry::Logic::Builder.call(&fn)
    end
  end

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
  end

  module FnRepo
    extend Dry::Container::Mixin

    register :ary_wrap do |input|
      Drymm['rules.ary'][input] ? input : [input]
    end
  end

  module TypesRepo
    extend Dry::Container::Mixin

    register :any, Dry::Types['any']

    register :ary, Dry::Types['array']

    register :hash, Dry::Types['hash']

    register :options, Dry::Types['hash'].default { Dry::Core::Constants::EMPTY_OPTS }

    register :meta, resolve(:options)

    register :symbol, Dry::Types['coercible.symbol']

    register :bool, Dry::Types['bool']

    register :const,
      proc { Drymm::S::ConstSchema },
      memoize: true

    register :class,
      proc { resolve(:const) },
      memoize: true

    register :blank_hash,
      proc { resolve(:hash).constrained(size: 0) },
      memoize: true

    register :wrapped_hash,
      proc { resolve(:ary).of(resolve(:hash)).constrained(size: 1) },
      memoize: true

    register :ary_wrap,
      proc { resolve(:ary) << Drymm['fn.ary_wrap'] },
      memoize: true

    register :ary_wrap_any,
      proc { resolve(:ary_wrap).of(resolve(:any)) },
      memoize: true

    register :ast_node,
      proc { Dry::Types::Constrained.new(resolve(:ary), rule: Drymm['rules.node']) },
      memoize: true

    register :member,
      proc { resolve(:class) | resolve(:sum_types) },
      memoize: true

    register :sum_types, proc { S::Types::Type.sum }

    register :sum_rules, proc { S::Logic::Rule.sum }

    register :types, proc { resolve(:ary_wrap).of(resolve(:sum_types)) }

    register :rules, proc { resolve(:ary_wrap).of(resolve(:sum_rules)) }

    register :fn, proc { S::Fn }

    register 'fn.type',
      proc { resolve(:symbol).enum(:id, :callable, :method) },
      memoize: true

    register 'fn.method',
      proc { Dry::Types::Tuple.build(resolve(:any), resolve(:symbol)) },
      memoize: true

    register 'fn.node',
      proc { resolve(:ary_wrap_any) | resolve('fn.method') },
      memoize: true

    register 'fn.tuple', memoize: true do
      Dry::Types::Tuple.build(resolve('fn.type'), resolve('fn.node')) |
      Dry::Types::Tuple.build(resolve('fn.type'), resolve(:const), resolve(:symbol))
    end

    namespace :const do
      register :literal, Dry::Types['class']

      register :schema, -> { S::ConstSchema }, memoize: true

      register :coercible, memoize: true do
        literal, schema = resolve(:literal), resolve(:schema)
        literal | (schema >= literal.constructor(&:to_literal))
      end
    end
  end

  merge RulesRepo, namespace: :rules
  merge FnRepo, namespace: :fn
  merge TypesRepo, namespace: :types

  keys.grep(/^rules/).each do |key|
    decorate key, with: LogicWrapper
  end

  register :sum, memoize: true do
    resolve('types.sum_rules') | resolve('types.sum_types')
  end
end