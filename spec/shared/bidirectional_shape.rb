# frozen_string_literal: true

RSpec.shared_examples "shape instance" do
  it { is_expected.to be_instance_of(described_class) }

  describe '#to_ast' do
    subject(:ast) { shape.to_ast }
    it { is_expected.to eq(input_ast) }
  end

  describe '#to_hash' do
    subject(:hash) { shape.to_hash }
    it { is_expected.to eq(output) }
  end

  describe '#compile' do
    subject(:compiled) { shape.compile }
    it { is_expected.to eq(input) }
  end
end

RSpec.shared_examples "bidirectional shape" do |label|
  context "with input of #{label}" do
    let(:input_ast) { input.to_ast }

    describe 'shape_branch.call' do
      it "produces the same result for both ast and hash inputs" do
        expect(shape_branch.(input_ast)).to eq(shape_branch.(output))
      end

      context 'on built shape' do
        subject(:shape) { shape_branch.(call_input) }

        context 'from AST array' do
          let(:call_input) { input_ast }
          include_examples 'shape instance'
        end

        context 'from Hash' do
          let(:call_input) { output }
          include_examples 'shape instance'
        end
      end
    end

    describe '.call' do
      it "produces the same result for both ast and hash inputs" do
        expect(described_class.(input_ast)).to eq(described_class.(output))
      end

      context 'on built shape' do
        subject(:shape) { described_class.(call_input) }

        context 'from AST array' do
          let(:call_input) { input_ast }
          include_examples 'shape instance'
        end

        context 'from Hash' do
          let(:call_input) { output }
          include_examples 'shape instance'
        end
      end
    end
  end
end
