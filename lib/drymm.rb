# frozen_string_literal: true

require_relative "drymm/version"
require "zeitwerk"
require "dry/core/constants"
require "dry/logic"
require "dry/logic/predicates"
require "dry/logic/builder"
require "dry/types"
require "dry/struct"
require "dry/monads/all"
require "dry/tuple"

# Load patches for dry-rb gems if need

unless Dry::Types::Printer.method_defined?(:visit_sum_constructors)
  require_relative "dry/types/printer/visit_sum_constructors"
end

unless Dry::Logic::Builder::Context.instance_method(:predicate).parameters.include?(%i[opt context])
  require_relative "dry/logic/builder/context_predicate_name"
end

require_relative "drymm/inflector"

# # Drym¹m² is for (¹)meta (²)mapping
#
# Drymm represents entities provided by {Dry::Logic} {Dry::Types}
# as a {Dry::Struct} classes under a {Drymm::Shapes} namespace.
#
# The core feature of Drymm::Shapes is an ability to cast an AST produced
# by that entities and structurize it for the following serialization (for example,
# into JSON). Also it provides an interface to load serialized data and compile it back
# to the Type or Logic entity.
#
# The casts perform by declaring expecting shapes under a specific {Drymm::Shapes::Branch}
# namespace without any conditional code but with a significant amount of recursion.
# Declared shapes composed into {Dry::Struct::Sum} which are in front of the casting behaviour.
module Drymm
  class << self
    # @!visibility private

    def loader
      @loader ||= Zeitwerk::Loader.for_gem.tap do |loader|
        if $PROGRAM_NAME == "bin/console"
          loader.enable_reloading
          loader.log!
        end
        loader.tag = "drymm"
        loader.inflector = Drymm::Inflector.new(__FILE__)
        loader.ignore "#{__dir__}/dry"
        loader.collapse "#{__dir__}/drymm/repos"
      end
    end

    # @return [Drymm::Inflector]
    def inflector
      loader.inflector
    end
  end

  loader.setup

  include Dry::Core::Constants

  extend Container

  # @!method self.[](key)
  #   @param [String, Symbol] key
  #   @return [mixed]

  # @!method self.resolve(key)
  #   @param [String, Symbol] key
  #   @return [mixed]

  merge Drymm::RulesRepo, namespace: :rules
  merge Drymm::FnRepo, namespace: :fn
  merge Drymm::TypesRepo, namespace: :types

  logic_builder = self["fn.logic_builder"]

  keys.grep(/^rules/).each do |key|
    decorate key, with: logic_builder
  end

  register :sum, memoize: true do
    (
      resolve("types.sum.rules") |
      resolve("types.sum.types")
    ).meta(recursive: "poly")
  end
end
