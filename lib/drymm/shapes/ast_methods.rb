# frozen_string_literal: true

module Drymm::Shapes
  module ASTMethods
    extend Mix

    # Fold data back into the plain AST
    # @return [Array]
    def to_ast
      type, *node = attributes.values_at(*self.class.keys_order)
      node.map! { |item| item.respond_to?(:to_ast) ? item.to_ast : item }
      node = node[0] if node.size == 1
      [type, node]
    end

    # Compile an instance back to original object
    # @see ClassMethods#compiler
    # @see ClassMethods#compiler_registry
    # @return [Object]
    def compile
      self.class.compiler.([to_ast]).dig(0)
    end

    module ClassMethods
      # @abstract
      #   Should be overriden in subclasses to return specific compiler
      # @param registry [container]
      # @return [#call]
      def compiler(registry = compiler_registry())
        raise NotImplementedError
      end

      # @abstract
      #   Should be overriden in subclasses to return specific registry
      # @return [container]
      def compiler_registry
        raise NotImplementedError
      end
    end
  end
end
