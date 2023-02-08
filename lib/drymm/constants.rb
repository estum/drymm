# frozen_string_literal: true

require 'dry/core/constants'
require 'dry/logic'
require 'dry/logic/builder'
require 'dry/types'

module Drymm
  module Constants
    include Dry::Core::Constants

    STR_Undefined = 'Undefined'

    SYM_PATTERN = /^[a-z]\w+/

    # Proc to bypass the given argument
    Bypass = -> (input) { input }.freeze

    # Proc to bypass the given argument wrapped in another proc
    WrappedBypass = proc { Bypass }.freeze
  end
end
