# frozen_string_literal: true

require "dry/core/version"

module Drymm
  # @api private
  module Container
    if Dry::Core::VERSION >= "1.0.0"
      include Dry::Core::Container::Mixin
    else
      require "dry/container"
      include Dry::Container::Mixin
    end

    # @private
    def self.extended(base)
      Dry::Core::Container::Mixin.extended(base)
    end

    private

    def alias_item(new_name, old_name)
      register new_name, memoize: true do
        resolve(old_name)
      end
    end
  end
end
