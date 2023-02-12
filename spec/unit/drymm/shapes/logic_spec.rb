# frozen_string_literal: true

module Drymm
  module Shapes
    RSpec.describe Logic do
      subject(:shape_branch) { described_class }

      describe ".sum" do
        subject(:sum) { shape_branch.sum.get }
        it { is_expected.to be_instance_of(Dry::Struct::Sum) }
      end

      include_context "with logic rules"
      include_context "with shapes of logic"

      describe Logic::Predicate do
        it_behaves_like "bidirectional shape", "predicate rule" do
          let(:input) { rule }
          let(:output) { filled_p_shape }
        end
      end

      describe Logic::RoutedUnary do
        it_behaves_like "bidirectional shape", "KEY rule" do
          let(:input)  { key_op }
          let(:output) { key_op_shape }
        end

        it_behaves_like "bidirectional shape", "ATTR rule" do
          let(:input)  { attr_op }
          let(:output) { attr_op_shape }
        end
      end

      describe Logic::Check do
        it_behaves_like "bidirectional shape", "CHECK rule" do
          let(:input)  { check_op }
          let(:output) { check_op_shape }
        end
      end

      describe Logic::Unary do
        it_behaves_like "bidirectional shape", "EACH rule" do
          let(:input)  { each_op }
          let(:output) { each_op_shape }
        end

        it_behaves_like "bidirectional shape", "NOT rule" do
          let(:input)  { not_key_op }
          let(:output) { not_key_op_shape }
        end
      end

      describe Logic::Grouping do
        it_behaves_like "bidirectional shape", "AND rule" do
          let(:input) { and_op }
          let(:output) { and_op_shape }
        end

        it_behaves_like "bidirectional shape", "OR rule" do
          let(:input) { or_op }
          let(:output) { or_op_shape }
        end

        it_behaves_like "bidirectional shape", "XOR rule" do
          let(:input) { xor_op }
          let(:output) { xor_op_shape }
        end

        it_behaves_like "bidirectional shape", "SET rule" do
          let(:input) { set_op }
          let(:output) { set_op_shape }
        end
      end
    end
  end
end
