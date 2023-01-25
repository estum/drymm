# frozen_string_literal: true

module Drymm
  class TypesCoder
    include Constants
    include Coder

    node_repo \
      const:        %i[cname],
      constrained:  %i[nominal rule],
      constructor:  %i[nominal fn],
      lax:          %i[node],
      nominal:      %i[_type meta],
      rule:         %i[rule],
      sum:          %i[left right meta],
      array:        %i[member meta],
      hash:         %i[opts meta],
      schema:       %i[keys options meta],
      json_hash:    %i[keys meta],
      json_array:   %i[member meta],
      params_hash:  %i[keys meta],
      params_array: %i[member meta],
      key:          %i[name required _type],
      enum:         %i[_type mapping],
      map:          %i[key_type value_type meta],
      any:          %i[meta]

    transforms \
      args:  -> (ary) { ary.map { |(key, val)| [key, Drymm['types.coder'].visit!(val)] } },
      meta:  proc(&:to_h),
      cname: -> (str) { Object.const_get(str) rescue str },
      any:   Bypass

    def initialize
      @compiler = Dry::Types::Compiler.new(Dry::Types)
    end

    def scope
      :types
    end
  end
end