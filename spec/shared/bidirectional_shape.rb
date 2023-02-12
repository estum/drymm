# frozen_string_literal: true

RSpec.shared_examples "shape transitions" do
  it { is_expected.to be_instance_of(described_class) }

  describe "#to_ast" do
    subject(:ast) { shape.to_ast }

    it { is_expected.to eq(input.to_ast) }
  end

  describe "#to_hash" do
    subject(:hash) { shape.to_hash }

    it { is_expected.to eq(output) }
  end

  describe "#compile" do
    subject(:compiled) { shape.compile }

    it { is_expected.to eq(result_of_compile) }
  end
end

RSpec.shared_examples "a built shape" do
  subject(:shape) { origin.call(call_input) }

  context "with the given input's AST" do
    let(:call_input) { input.to_ast }

    it { is_expected.to eq(origin.call(output)) }

    include_examples "shape transitions"
  end

  context "with the given output hash" do
    let(:call_input) { output }

    include_examples "shape transitions"
  end
end

RSpec.shared_examples "bidirectional shape" do |label|
  context "with #{label}" do
    case label
    when "Fn::Method", "Fn::ID"
      let(:result_of_compile) { input.fn }
    else
      let(:result_of_compile) { input }
    end

    context "when the origin is a described class" do
      let(:origin) { described_class }

      include_examples "a built shape"
    end

    context "when the origin is a sum type of shaping branch" do
      let(:origin) { shape_branch }

      include_examples "a built shape"
    end
  end
end
