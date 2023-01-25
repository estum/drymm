# frozen_string_literal: true

require 'dry/core/constants'
require 'dry/logic'
require 'dry/logic/builder'
require 'dry/types'

module Drymm
  module Constants
    include Dry::Core::Constants
    include Dry::Logic

    CONST_VALUE = Dry::Types['coercible.symbol'].constrained(eql: :const)

    CONST_RULE = Builder.call { key(name: 0) { case?(CONST_VALUE) } }

    BLANK_HASH = Dry::Types['hash'].constrained(size: 0)

    WRAPPED_HASH = Dry::Types['array'].of(Dry::Types['hash']).constrained(size: 1)

    STR_Undefined = 'Undefined'

    SYM_PATTERN = /^[a-z]\w+/

    Bypass = proc(&:itself)

    WrappedBypass = proc { Bypass }
  end
end
