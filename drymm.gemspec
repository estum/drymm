# frozen_string_literal: true

require_relative "lib/drymm/version"

Gem::Specification.new do |spec|
  spec.name          = "drymm"
  spec.authors       = ["estum"]
  spec.email         = ["anton.estum@gmail.com"]
  spec.license       = "MIT"
  spec.version       = Drymm::VERSION

  spec.summary       = "Universal meta-mapper for dry-rb family AST."
  spec.description   = "Drymm helps to tranform AST of data structures like Dry::Types or Dry::Logic into serializable objects."
  spec.homepage      = "https://github.com/estum/drymm"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "drymm.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/estum/drymm"
  spec.metadata["changelog_uri"]     = "https://github.com/estum/drymm/blob/main/CHANGELOG.md"

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_runtime_dependency "concurrent-ruby"
  spec.add_runtime_dependency "dry-core"
  spec.add_runtime_dependency "dry-container"
  spec.add_runtime_dependency "dry-inflector"
  spec.add_runtime_dependency "dry-logic"
  spec.add_runtime_dependency "dry-types"
  spec.add_runtime_dependency "dry-struct"
  spec.add_runtime_dependency "dry-monads"
  spec.add_runtime_dependency "dry-types-tuple", ">= 0.1.4"
  spec.add_runtime_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
