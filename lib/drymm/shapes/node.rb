# frozen_string_literal: true

module Drymm::Shapes
  # @abstract
  #   {Dry::Struct} abstract subclass, extended with {::Dry::Tuple::StructClassInterface}
  class Node < Dry::Struct
    transform_keys &:to_sym

    abstract

    extend Dry::Tuple::StructClassInterface

    include Drymm::Constants

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
      def type_identifier(class_or_name = self)
        name =
          if class_or_name.is_a?(::Module)
            Drymm['fn.type_identifier'][class_or_name.name]
          else
            class_or_name.to_sym
          end
        Drymm['types.sym'].constrained(eql:  name)
      end

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

      # @api private
      # Invokes Dry::Tuple::StructClassInterface#auto_tuple each time an
      # attribute is declared.
      private def define_accessors(keys)
        super
        auto_tuple(*keys)
      end
    end

    # Fold data back into the plain AST
    # @return [Array]
    def to_ast
      type, *node = attributes.values_at(*self.class.keys_order)
      node.map! { |item| item.respond_to?(:to_ast) ? item.to_ast : item }
      node = node[0] if node.size == 1
      [type, node]
    end

    # Compile data back to original` object
    def compile
      self.class.compiler.([to_ast]).dig(0)
    end
  end
end
