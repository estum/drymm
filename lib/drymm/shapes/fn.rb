# frozen_string_literal: true

module Drymm::Shapes
  # Namespace of function shapes, i.e. procs or methods, used by {Dry::Types}
  module Fn
    extend SumEnclosure

    # Represents functions, stored in {Dry::Types::FnContainer}
    class ID < Node
      attribute :type, type_identifier(:id)
      attribute :id, Drymm['types.sym']
    end

    # Represent callable objects but not an internal procs
    class Callable < Node
      attribute :type, type_identifier(:callable)
      attribute :callable, Drymm['types.any']

      # @!attribute callable [r]
      #   @return [#call]
    end

    # Represents a method calls
    class Method < Node
      attribute :type, type_identifier(:method)
      attribute :target, Drymm['types.const']
      attribute :name, Drymm['types.sym']

      def to_ast
        super.flatten(1)
      end
    end

    self.sum = ID | Callable | Method
  end
end
