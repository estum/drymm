# frozen_string_literal: true

module Drymm
  class FactoryMap < Concurrent::Map
    include Constants

    # @param fn [Proc] applied to the value before it will be stored
    # @param key_fn [Proc] applied to the key before it will be stored
    # @return [FactoryMap] with predefined default_proc storing the missing items with coercing
    def self.factory(fn: Undefined, key_fn: Bypass, &block)
      value_fn = Undefined.default(fn, block)
      new { |map, key| map.store_computed_value(key_fn[key], value_fn[key]) }
    end

    public :store_computed_value
  end
end
