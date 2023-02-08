# frozen_string_literal: true

RSpec.shared_examples "bidirectional coder" do |label|
  let(:ast_args) { [] }

  context "with #{label} as input" do
    let(:input_ast) { input.to_ast }

    describe '#hash_to_ast(output)' do
      subject(:ast) { coder.hash_to_ast(**output) }
      it { is_expected.to eq(input_ast) }
    end

    describe '#serialize(input)' do
      subject(:serialized) { coder.serialize(input, *ast_args) }
      it { is_expected.to eq(output) }

      context '…and then #deserialize(plain) back' do
        subject(:compiled) { coder.deserialize(serialized) }
        it { is_expected.to eq(input) }
      end
    end

    describe '#deserialize(output)' do
      subject(:compiled) { coder.deserialize(output) }
      it { is_expected.to eq(input) }

      context '…and then #serialize(compiled) back' do
        subject(:serialized) { coder.serialize(compiled) }
        it { is_expected.to eq(output) }
      end

      context '…and then compiled.to_ast' do
        subject(:ast) { compiled.to_ast }
        it { is_expected.to eq(input_ast) }
      end
    end
  end
end
