# frozen_string_literal: true

module Drymm
  # @api private
  module FnRepo
    extend Container

    register :ary_wrap do |input|
      Drymm["rules.ary"][input] ? input : [input]
    end

    register :logic_builder do |fn|
      Dry::Logic::Builder.call(&fn)
    end

    register :type_identifier do |name|
      Drymm.inflector.underscore(Drymm.inflector.demodulize(name)).to_sym
    end
  end
end
