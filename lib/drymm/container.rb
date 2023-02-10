# frozen_string_literal: true

require 'dry/container'

module Drymm
  # @api private
  module Container
    include Dry::Container::Mixin

    # @private
    def self.extended(base)
      Dry::Container::Mixin.extended(base)
    end

    class OptionsWrapper < SimpleDelegator
      singleton_class.alias_method :call, :new

      def initialize(opts, &block)
        super(block.binding.receiver)
        @opts = opts
        block.arity > 0 ? block.(self) : instance_exec(&block)
      end

      def register(*args, **opts)
        super(*args, **opts, **@opts)
      end
    end

    private_constant :OptionsWrapper

    private

    def alias_item(new_name, old_name)
      register new_name, memoize: true do
        resolve(old_name)
      end
    end

    def with_options(**opts, &block)
      OptionsWrapper.(opts, &block)
    end
  end
end
