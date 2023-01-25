# frozen_string_literal: true

module Drymm
  class LogicCoder
    include Coder

    node_repo \
      const:       %i[cname],
      and:         %i[left right],
      attr:        %i[path rule],
      check:       %i[keys rule],
      each:        %i[rule],
      implication: %i[left right],
      key:         %i[path rule],
      negation:    %i[rule],
      or:          %i[left right],
      set:         %i[rules],
      xor:         %i[rules],
      predicate:   %i[name args]

    transforms \
      cname: -> (str) { Object.const_get(str) rescue str },
      args: -> (ary) { ary.map { |(key, val)| [key, Drymm['logic.coder'].ast_to_hash(val)] } }


    def initialize
      @compiler = Dry::Logic::RuleCompiler.new(Dry::Logic::Predicates)
    end

    def scope
      :logic
    end
  end
end
