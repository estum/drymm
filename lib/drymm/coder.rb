# frozen_string_literal: true

require 'dry/core/class_attributes'

module Drymm
  module Coder
    NodeRepo = -> (klass, ivar, decorator, input) {
      repo = klass.instance_variable_get(ivar) if klass.instance_variable_defined?(ivar)
      repo ||= Dry::Container.new
      input.each { |type, keys| repo.register type, (decorator ? decorator.(type, keys) : keys) }
      repo
    }.curry(4)

    include Interface
    include Visitors

    def self.included(base)
      super if defined?(super)
      base.extend Dry::Core::ClassAttributes
      base.extend ClassMethods
      base.defines :node_repo, coerce: NodeRepo[base, :@node_repo, Nodes::Definition.method(:new)]
      base.defines :transforms, coerce: NodeRepo[base, :@transforms, nil]
    end

    def hash_to_ast(type:, **input)
      type = type.to_sym
      mapped = node_repo.resolve(type)

      if mapped.respond_to?(:keys)
        keys = mapped.keys
        assoc = keys.map { |k| safe_transform(k, input[k]) }
        assoc = assoc[0] if keys.size == 1
        type == :const ? assoc : [type, assoc]
      else
        [:_type, visit!(input)]
      end
    end

    def ast_to_hash(ast)
      if ast.is_a?(Array) && ast.size > 0 && !ast[0].is_a?(Array)
        ast = ast.dup
        result = node_repo.resolve(ast.shift) { Undefined }
        ast = ast[0] if ast.size == 1 && ast[0].is_a?(Array)
        return result.(ast, scope: scope) if !Undefined.equal?(result)
      end
      visit!(ast)
    end

    def scope
      raise NotImplementedError
    end

    def node_repo
      self.class.node_repo
    end

    def transforms
      self.class.transforms
    end

    def safe_transform(key, value)
      Nodes[:safe_transform][key, scope][value]
    end

    module ClassMethods
      def register(*args, **opts, &block)
        node_repo.register(*args, **opts, &block)
      end

      def transform(*args, **opts, &block)
        transforms.register(*args, **opts, &block)
      end
    end
  end
end
