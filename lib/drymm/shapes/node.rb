# frozen_string_literal: true

module Drymm::Shapes
  # @abstract
  #   {Dry::Struct} abstract subclass, extended with {::Dry::Tuple::StructClassInterface}
  class Node < Dry::Struct
    transform_keys &:to_sym

    abstract

    extend Dry::Tuple::StructClassInterface
    include Drymm::Constants
    include JSONMethods
    include ASTMethods

    class << self
      # @overload type_identifier(klass)
      #   Generates identifier from the given class name
      #   @param klass [Class]
      # @overload type_identifier(name)
      #   Coerces the given name to symbol and uses it as a node type identifier
      #   @param name [#to_sym]
      # @return [Dry::Types::Type]
      #   coercible symbol type with specific value — node type identifier
      #   (declared, for example, as `type` in {Drymm::Shape::LogicNode.inherited})
      # @note
      #   To hook the assigned type identifier for specific subclass, just override
      #   this method.
      # @example Hook the type value
      #   class Something < Drymm::S::Node
      #     def self.type_identifier(*)
      #       super(:hooked)
      #     end
      #   end
      def type_identifier(input = self)
        case input
        when ::String, ::Symbol
          Drymm['types.sym'].constrained(eql: input.to_sym)
        when ::Array
          Drymm['types.sym'].enum(*input)
        when ::Module
          type_identifier(Drymm['fn.type_identifier'][input.name])
        else
          raise ArgumentError
        end
      end

      # Shorthand to declare type as a enum
      # @param input [Array<Symbol>]
      # @return [Dry::Types[Enum<Symbol>]]
      def type_enum(*input)
        type_identifier(input)
      end

      # @api private
      # Invokes Dry::Tuple::StructClassInterface#auto_tuple each time an
      # attribute is declared.
      private def define_accessors(keys)
        super
        auto_tuple(*keys)
      end
    end
  end
end
