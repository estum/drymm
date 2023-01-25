module Drymm
  module Nodes
    include Constants
    extend Dry::Container::Mixin

    register :transforms, memoize: true do
      Dry::Container.new
    end

    register :match do |input|
      case input
      when STR_Undefined ; :und
      when SYM_PATTERN   ; :sym
      when BLANK_HASH    ; :und
      when CONST_RULE    ; :const
      when Hash          ; :hash
      when Array         ; :ary
      when Class         ; :class
                      else :itself
      end
    end

    register :safe_transform do |key, scope = Undefined|
      if Undefined.equal?(scope)
        resolve(:transforms).resolve(key, &Constants::WrappedBypass)
      else
        Drymm["#{scope}.coder"].transforms.resolve(key) do
          resolve(:transforms).resolve(key, &Constants::WrappedBypass)
        end
      end
    end

    # @overload tranform(mapping_hash)
    #   Registers multiple items in transforms
    #   @param mapping_hash [Hash { Symbol => Array<Any> }]
    # @overload transform(key, *args, repo: nil, **opts, &block)
    #   Registers single item in transforms
    #   @see Dry::Container::Mixin#register
    def self.transform(*args, repo: nil, **opts, &block)
      repo ||= resolve(:transforms)
      if opts.size > 0 && args.size == 0
        opts.each do |key, args|
          args = [args] unless args.is_a?(Array)
          kw = args.pop if args[-1].is_a?(Hash)
          transform(key, *args, repo: repo, **kw.to_h)
        end
      else
        repo.register(*args, **opts, &block)
      end
    end

    class Definition
      attr_reader :type, :keys, :template
      include Dry::Equalizer(:type, :keys)

      # @!attribute type [r]
      #   @return [Symbol]
      #
      # @!attribute keys [r]
      #   @return [Array<Symbol>]
      #
      # @attribute template [r]
      #   @return [Hash { Symbol => ValueTransform }]

      def initialize(type, keys)
        @type, @keys = type, keys
        @template = { type: @type, **ValueTransform.populate(*@keys) }.freeze
      end

      def call(nodes, scope: Undefined)
        @template.transform_values do |value|
          value.is_a?(ValueTransform) ? value.(nodes, scope) : value
        end
      end

      alias_method :[], :call
      alias_method :yield, :call
      alias_method :===, :call

      def to_proc
        @fn ||= method(:call).to_proc
      end
    end

    class ValueTransform < DelegateClass(Proc)
      attr_reader :key, :index
      include Dry::Equalizer(:key, :index)

      # @!attribute key [r]
      #   @return [Symbol]
      #
      # @!attribute index [r]
      #   @return [Integer]

      # @param key [Symbol, String]
      # @param index [Integer]
      # @param fn [Proc]
      # @return self
      def initialize(key, index, fn = nil)
        @key, @index = key, index
        safe_transform = Nodes[:safe_transform]
        fn ||=
          proc do |nodes, scope = Undefined|
            safe_transform.(@key, scope).(nodes[@index])
          end
        super(fn)
        freeze
      end

      # @!method call(nodes, scope = Undefined)
      #   @param nodes [Array]
      #   @param scope [Symbol]

      # @!method to_proc

      extend Dry::Core::Cache

      # Fetch cached or construct
      # @param key [Symbol]
      # @param index [Integer]
      # @return [ValueTransform]
      def self.[](key, index)
        fetch_or_store(key, index) { new(key, index) }
      end

      # Build hash with the given keys on cached or constructed instances
      # @param keys [Array<Symbol, String>]
      # @return [Hash { Symbol => ValueTransform }]
      def self.populate(*keys)
        keys.each_with_index.with_object({}) do |(key, index), dict|
          dict[key.to_sym] = self[key, index]
        end
      end
    end
  end
end
