# frozen_string_literal: true

module Drymm
  module Coder
    module Visitors
      # @param type [Symbol]
      # @param node [Any]
      # @return [Any]
      def visit(type, node)
        Drymm["#{scope}.visitors_map"][type][node]
      end

      # Shurtcut for `visit(match(node), node)`
      # @see #visit
      # @see #match
      # @param node [Any]
      # @return [Any]
      def visit!(node)
        visit(match(node), node)
      end

      # @param node [Any]
      # @return [Any]
      def match(node)
        Nodes[:match][node]
      end

      def visit_und(*)
        Undefined
      end

      def visit_sym(node)
        node.to_sym
      end

      def visit_itself(node)
        node
      end

      def visit_class(node)
        { type: :const, cname: node.to_s }
      end

      def visit_const(node)
        visit!(node.last)
      end

      def visit_ary(nodes)
        nodes.map { |node| ast_to_hash(node) }
      end

      def visit_hash(node)
        hash_to_ast(**node.transform_keys(&:to_sym))
      end
    end
  end
end
