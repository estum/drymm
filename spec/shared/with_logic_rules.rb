# frozen_string_literal: true

RSpec.shared_context "with logic rules" do
  include_context "with logic predicates"

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
end
