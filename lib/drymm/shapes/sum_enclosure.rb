# frozen_string_literal: true

module Drymm::Shapes
  module SumEnclosure
    include Dry::Types::Type
    include Dry::Types::Meta

    attr_reader :sum

    def sum=(value)
      override = @sum
      @sum = value
    ensure
      finalize_sum!(override) if override
    end

    # @!method call(input, &block)
    #   @overload call(type: :id, id:)
    #     @param id [Symbol, String]
    #   @overload call(type: :callable, callable:)
    #     @param callable [#call]
    #   @overload call(type: :method, target:, name:)
    #     @param target [#(name)] namespace
    #     @param name [Symbol, String]
    #   @return [self]

    # @api private
    def call_unsafe(input)
      @sum.(input)
    end

    # @api private
    def call_safe(input, &block)
      @sum.(input, &block)
    end

    # @api private
    def try(input, &block)
      @sum.try(input, &block)
    end

    private

    def finalize_sum!(base)
      base.descendants.each do |subclass|
        changed = false
        new_keys = subclass.schema.keys.map do |key|
          if key.type == base
            changed = true
            key.send(:__new__, @sum)
          elsif key.type.respond_to?(:member) && key.type.member == base
            changed = true
            key.send(:__new__, key.type.of(@sum))
          else
            key
          end
        end
        if changed
          subclass.instance_variable_set :@schema, subclass.schema.schema(new_keys)
          subclass.retuple
        end
      end
    end
  end
end
