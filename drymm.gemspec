# frozen_string_literal: true

require_relative "lib/drymm/version"

Gem::Specification.new do |spec|
  spec.name          = "drymm"
  spec.authors       = ["estum"]
  spec.email         = ["anton.estum@gmail.com"]
  spec.license       = "MIT"
  spec.version       = Drymm::VERSION

  spec.summary       = "Universal meta mapper for dry-logic & dry-types."
  spec.description   = "Drymm maps entities from Dry::Logic & Dry::Types into structs for a serialization purpose."
  spec.homepage      = "https://github.com/estum/drymm"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "drymm.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/estum/drymm"
  spec.metadata["github_repo"]       = "ssh://github.com/estum/drymm"
  spec.metadata["changelog_uri"]     = "https://github.com/estum/drymm/blob/main/CHANGELOG.md"

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_runtime_dependency "concurrent-ruby", '~> 1.0'
  spec.add_runtime_dependency "concurrent-ruby-ext", '~> 1.0'
  spec.add_runtime_dependency "dry-core"
  spec.add_runtime_dependency "dry-inflector"
  spec.add_runtime_dependency "dry-logic"
  spec.add_runtime_dependency "dry-monads"
  spec.add_runtime_dependency "dry-struct"
  spec.add_runtime_dependency "dry-types"
  spec.add_runtime_dependency "dry-types-tuple", ">= 0.1.4"
  spec.add_runtime_dependency "zeitwerk"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
end
