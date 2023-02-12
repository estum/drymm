# frozen_string_literal: true

module Drymm
  module Shapes
    RSpec.describe Fn do
      subject(:shape_branch) { described_class }

      describe ".sum" do
        subject(:sum) { shape_branch.sum.get }
        it { is_expected.to be_instance_of(Dry::Struct::Sum) }
      end

      describe Fn::ID do
        it_behaves_like "bidirectional shape", "Fn::ID" do
          let(:input) { Dry::Types["coercible.symbol"].fn }
          let(:output) { { type: :id, id: input.to_ast[1] } }
        end
      end

      xdescribe Fn::Callable do
        it_behaves_like "bidirectional shape", "Fn::Callable" do
          let(:input) { [:callable, Dry::Logic::Builder] }
          let(:output) { { type: :callable, callable: Dry::Logic::Builder } }
        end
      end

      describe Fn::Method do
        it_behaves_like "bidirectional shape", "Fn::Method" do
          let(:input) { Dry::Types["params.array"].fn }
          let(:output) do
            { type: :method, target: { type: :const, name: "Dry::Types::Coercions::Params" }, name: :to_ary }
          end
        end
      end
    end
  end
end
