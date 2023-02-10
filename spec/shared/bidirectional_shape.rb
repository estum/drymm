# frozen_string_literal: true

RSpec.shared_examples "bidirectional shape" do |label|
  context "with #{label} as input" do
    let(:input_ast) { input.to_ast }

    describe '#[output].to_ast' do
      subject(:ast) { shape_branch.sum[output].to_ast }
      it { is_expected.to eq(input_ast) }
    end

    describe '#[ast_of_input].to_h' do
      subject(:serialized) { shape_branch.sum[input_ast].to_h }
      it { is_expected.to eq(output) }

      context '…and then #[serialized] back' do
        subject(:compiled) { shape_branch.sum[serialized].compile }
        it { is_expected.to eq(input) }
      end
    end

    # describe '#[output]' do
    #   subject(:compiled) { shape_branch[output] }
    #   it { is_expected.to eq(input) }
    #
    #   context '…and then #serialize(compiled) back' do
    #     subject(:serialized) { coder.serialize(compiled) }
    #     it { is_expected.to eq(output) }
    #   end
    #
    #   context '…and then compiled.to_ast' do
    #     subject(:ast) { compiled.to_ast }
    #     it { is_expected.to eq(input_ast) }
    #   end
    # end
  end
end
