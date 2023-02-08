# frozen_string_literal: true

module Drymm
  RSpec.describe LogicCoder do
    subject(:coder_class) { described_class }

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

    context 'with instantiated coder' do
      subject(:coder) { coder_class.new }

      it_behaves_like 'bidirectional coder', 'predicate rule' do
        let(:input) { rule }
        let(:output) { serialized_rule }
      end

      it_behaves_like 'bidirectional coder', 'KEY rule' do
        let(:input) { key_op }
        let(:output) { serialized_key_op }
      end

      it_behaves_like 'bidirectional coder', 'ATTR rule' do
        let(:input) { attr_op }
        let(:output) { { type: :attr, path: :email, rule: serialized_rule } }
      end

      it_behaves_like 'bidirectional coder', 'CHECK rule' do
        let(:input) { check_op }
        let(:output) { { type: :check, keys: %i[email], rule: serialized_rule } }
      end

      it_behaves_like 'bidirectional coder', 'NOT rule' do
        let(:input) { not_key_op }
        let(:output) { { type: :not, rule: serialized_key_op } }
      end

      it_behaves_like 'bidirectional coder', 'AND rule' do
        let(:input) { and_op }
        let(:output) { { type: :and, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional coder', 'OR rule' do
        let(:input) { or_op }
        let(:output) { { type: :or, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional coder', 'XOR rule' do
        let(:input) { xor_op }
        let(:output) { { type: :xor, rules: [serialized_key_op, serialized_rule] } }
      end

      it_behaves_like 'bidirectional coder', 'SET rule' do
        let(:input) { set_op }
        let(:output) { { type: :set, rules: [serialized_rule] } }
      end

      it_behaves_like 'bidirectional coder', 'EACH rule' do
        let(:input) { each_op }
        let(:output) { { type: :each, rule: serialized_rule } }
      end
    end
  end
end
