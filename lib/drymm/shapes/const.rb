# frozen_string_literal: true

module Drymm::Shapes
  # The intermediary shape class to handle bidirectional
  # serialization of classes & modules, referenced in the node's AST.
  #
  # @example Wraps
  #   Drymm::Shapes::Const[Dry]
  #   # => #<Drymm::Shapes::Const name='Dry'>
  #
  #   Drymm::Shapes::Const[name: 'Dry'].to_literal
  #   # => Dry
  class Const < Node
    attribute :type, type_identifier(:const).default { :const }
    attribute :name, Drymm['types.str']

    include Dry.Equalizer(:name, immutable: true)

    # Constantize by name
    # @return [Class, Module]
    def to_literal
      ::Object.const_get(name)
    end

    alias_method :to_ast, :to_literal

    class << self
      # @!method call(input, &block)
      #   @overload call(class_or_module_literal)
      #     @param class_or_module_literal [Class, Module]
      #   @overload call(hash)
      #     @param hash [Hash { :type => :const, :name => String }]
      #   @return [self]

      # @return [Class(Module)]
      def primitive
        ::Module
      end

      # @param input [Any]
      # @return [true] if the input is an instance of {Module} class.
      def primitive?(input)
        input.is_a?(primitive)
      end

      # @api private
      def call_unsafe(input)
        return super unless primitive?(input)
        super(name: input)
      end

      # @api private
      def call_safe(input, &block)
        return super unless primitive?(input)
        super(name: input, &block)
      end

      # @api private
      def try(input, &block)
        return super unless primitive?(input)
        super(name: input, &block)
      end
    end
  end
end
