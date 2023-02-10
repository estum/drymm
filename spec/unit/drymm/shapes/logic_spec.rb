# frozen_string_literal: true

module Drymm::Shapes
  RSpec.describe Logic do
    subject(:shape_branch) { Logic }

    describe '.sum' do
      subject(:sum) { shape_branch.sum }
      it { is_expected.to be_instance_of(Dry::Struct::Sum) }
    end

    include_context "logic predicates"

    let(:rule)       { Dry::Logic::Rule::Predicate.build(filled?) }
    let(:key_op)     { Dry::Logic::Operations::Key.new(rule, name: :email) }
    let(:attr_op)    { Dry::Logic::Operations::Attr.new(rule, name: :email) }
    let(:check_op)   { Dry::Logic::Operations::Check.new(rule, keys: [:email]) }
    let(:not_key_op) { Dry::Logic::Operations::Negation.new(key_op) }
    let(:and_op)     { key_op & rule }
    let(:or_op)      { key_op | rule }
    let(:xor_op)     { key_op ^ rule }
    let(:set_op)     { Dry::Logic::Operations::Set.new(rule) }
    let(:each_op)    { Dry::Logic::Operations::Each.new(rule) }

    def serialized_rule(arg = undefined)
      { type: :predicate,
        name: :filled?,
        args: [[:input, arg]] }
    end

    def serialized_key_op(arg = undefined)
      { type: :key,
        path: :email,
        rule: serialized_rule(arg) }
    end

    describe Logic::Predicate do
      it_behaves_like 'bidirectional shape', 'predicate rule' do
        let(:input) { rule }
        let(:output) { serialized_rule }
      end
    end

    describe Logic::RoutedUnary do
      it_behaves_like 'bidirectional shape', 'KEY rule' do
        let(:input) { key_op }
        let(:output) { serialized_key_op }
      end

      it_behaves_like 'bidirectional shape', 'ATTR rule' do
        let(:input) { attr_op }
        let(:output) { { type: :attr, path: :email, rule: serialized_rule } }
      end
    end

    describe Logic::Check do
      it_behaves_like 'bidirectional shape', 'CHECK rule' do
        let(:input) { check_op }
        let(:output) { { type: :check, keys: %i[email], rule: serialized_rule } }
      end
    end

    describe Logic::Unary do
      it_behaves_like 'bidirectional shape', 'EACH rule' do
        let(:input) { each_op }
        let(:output) { { type: :each, rule: serialized_rule } }
      end

      it_behaves_like 'bidirectional shape', 'NOT rule' do
        let(:input) { not_key_op }
        let(:output) { { type: :not, rule: serialized_key_op } }
      end
    end

    describe Logic::Grouping do
      it_behaves_like 'bidirectional shape', 'AND rule' do
        let(:input) { and_op }
        let(:output) { { type: :and, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional shape', 'OR rule' do
        let(:input) { or_op }
        let(:output) { { type: :or, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional shape', 'XOR rule' do
        let(:input) { xor_op }
        let(:output) { { type: :xor, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional shape', 'SET rule' do
        let(:input) { set_op }
        let(:output) { { type: :set, rules: [serialized_rule] } }
      end
    end
  end
end
