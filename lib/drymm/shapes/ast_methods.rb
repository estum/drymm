# frozen_string_literal: true

module Drymm
  module Shapes
    # AST-related methods mixin
    module ASTMethods
      extend Mix

      # Fold data back into the plain AST
      # @return [Array]
      def to_ast
        type, *node = attributes.values_at(*self.class.keys_order)
        node = recursive_ast(node)
        node = node[0] if node.size == 1
        [type, node]
      end

      # Compile an instance back to original object
      # @see ClassMethods#compiler
      # @see ClassMethods#compiler_registry
      # @return [Object]
      def compile
        self.class.compiler.call([to_ast])[0]
      end

      private

      def recursive_ast(node)
        case node
        when Array
          node.map { |item| recursive_ast(item) }
        when Hash
          node.transform_values { |item| recursive_ast(item) }
        when Drymm["types.ast"]
          node.to_ast
        else
          node
        end
      end

      # @api private
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
end
