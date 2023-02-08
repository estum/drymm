# frozen_string_literal: true

module Drymm::S
  class ConstSchema < Node
    attributes type: Node.type_identifier(:const).default { :const },
               name: Dry::Types['coercible.string']

    include Dry.Equalizer(:name, immutable: true)

    def to_literal
      Object.const_get(name)
    end

    def self.call_safe(input, &block)
      if input.is_a?(Module)
        super(name: input, &block)
      else
        super
      end
    end

    def self.call_unsafe(input)
      if input.is_a?(Module)
        super(name: input)
      else
        super
      end
    end

    def self.try(input, &block)
      if input.is_a?(Module)
        super(name: input, &block)
      else
        super
      end
    end
  end
end
