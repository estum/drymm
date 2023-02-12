# frozen_string_literal: true

require "dry/inflector"

module Drymm
  # @api private
  class Inflector < Dry::Inflector
    def initialize(root_file)
      super() do |inflections|
        inflections.acronym "AST"
        yield(inflections) if block_given?
      end
      namespace     = File.basename(root_file, ".rb")
      lib_dir       = File.dirname(root_file)
      @version_file = File.join(lib_dir, namespace, "version.rb")
    end

    def camelize(basename, abspath)
      abspath == @version_file ? "VERSION" : super(basename)
    end
  end
end
