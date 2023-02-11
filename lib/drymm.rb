# frozen_string_literal: true

require_relative 'drymm/version'
require 'zeitwerk'
require 'dry/core/constants'
require 'dry/logic'
require 'dry/logic/predicates'
require 'dry/logic/builder'
require 'dry/types'
require 'dry/struct'
require 'dry/monads/all'
require 'dry/types'
require 'dry/tuple'

# Load patches for dry-rb gems if need

require_relative 'dry/types/printer/visit_sum_constructors' if !Dry::Types::Printer.method_defined?(:visit_sum_constructors)
require_relative 'dry/logic/builder/context_predicate_name' if !Dry::Logic::Builder::Context.instance_method(:predicate).parameters.include?([:opt, :context])

require_relative 'drymm/inflector'

module Drymm
  def self.loader
    @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      if $0 == 'bin/console'
        loader.enable_reloading
        loader.log!
      end
      loader.tag = 'drymm'
      loader.inflector = Drymm::Inflector.new(__FILE__)
      loader.ignore "#{__dir__}/dry"
      loader.collapse "#{__dir__}/drymm/repos"
    end
  end

  def self.inflector
    loader.inflector
  end

  loader.setup

  module Constants
    include Dry::Core::Constants
  end

  include Constants

  extend Container

  merge Drymm::RulesRepo, namespace: :rules
  merge Drymm::FnRepo, namespace: :fn
  merge Drymm::TypesRepo, namespace: :types

  logic_builder = self['fn.logic_builder']

  keys.grep(/^rules/).each do |key|
    decorate key, with: logic_builder
  end

  register :sum, memoize: true do
    resolve('types.sum.rules') | resolve('types.sum.types')
  end
end