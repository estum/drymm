# frozen_string_literal: true

require_relative 'drymm/version'
require 'zeitwerk'
require 'dry/container'

module Drymm
  def self.loader
    @loader ||= begin
      loader = Zeitwerk::Loader.for_gem
      loader.tag = 'drymm'
      loader
    end
  end

  loader.setup

  extend Dry::Container::Mixin
  include Constants

  namespace :logic do
    register :coder, memoize: true do
      LogicCoder.new
    end
  end

  namespace :types do
    register :coder, memoize: true do
      TypesCoder.new
    end

    register :node_mapper, memoize: true do
      proc { |coder, input|
        case input
        when Array; coder.ast_to_hash(input)
        when Class; coder.visit!(input)
        when Hash;  coder.hash_to_ast(**input)
        else input
        end
      }.curry(2).(resolve :coder)
    end
  end

  -> ns {
    namespace(ns) do
      register :visitors_map, memoize: true do
        FactoryMap.factory { |key| resolve(:coder).method(:"visit_#{key}").to_proc }
      end

      register :coder_method, memoize: true do
        FactoryMap.factory \
          fn: -> (coder, name) { coder.method(name) }.
            curry(2).
            (resolve :coder)
      end
    end
  }.then { |fn| ::Enumerator::Yielder.new(&fn) }.
    then { |y|
      y << :logic
      y << :types
    }

  list_map_builder = proc { |mapper, input| input.map(&mapper) }.curry(2)

  logic_ast_to_hash = self['logic.coder_method'][:ast_to_hash]
  types_node        = self['types.node_mapper']

  Nodes.transform \
    rule:      logic_ast_to_hash,
    rules:     list_map_builder[logic_ast_to_hash],
    args:      -> (fn, ary) { ary.map { |(key, val)| [key, fn.(val)] } }.curry(2).(logic_ast_to_hash),
    cname:     -> (input) { Object.const_get(input) rescue input },
    predicate: logic_ast_to_hash,
    _type:     types_node,
    left:      types_node,
    right:     types_node,
    nominal:   types_node,
    types:     list_map_builder[types_node]
end