# frozen_string_literal: true

require "pathname"
require "drymm"

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join("shared/**/*.rb")].sort.each(&method(:require))

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  Module.new {
    def undefined
      Dry::Core::Constants::Undefined
    end
  }.then { |shorthands|
    config.extend shorthands
    config.include shorthands
  }
end
