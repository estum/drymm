# frozen_string_literal: true

module Drymm::S
  class Const
    include Dry::Initializer[undefined: false].define -> do
      param :ref, -> (ref, const) { const.coerce_ref(ref) }
    end

    def self.coerce_ref(ref)

    end
  end
end
