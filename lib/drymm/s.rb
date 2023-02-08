# frozen_string_literal: true

module Drymm
  module S
    include Constants

    def self.sum
      Drymm['sum']
    end

    def self.call(input)
      sum.call(input)
    end
  end
end
