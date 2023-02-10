# frozen_string_literal: true

require 'dry/inflector'

module Drymm
  # @api private
  class Inflector < Dry::Inflector
    def initialize(root_file, &block)
      super(&block)
      namespace     = File.basename(root_file, ".rb")
      lib_dir       = File.dirname(root_file)
      @version_file = File.join(lib_dir, namespace, "version.rb")
    end

    def camelize(basename, abspath)
      abspath == @version_file ? "VERSION" : super(basename)
    end
  end
end
