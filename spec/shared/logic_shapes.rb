RSpec.shared_context 'logic shapes' do
  def predicate_shape(name, input: undefined, **args)
    { type: :predicate, name: name, args: [*args.to_a, [:input, input]] }
  end

  let(:filled_p_shape)   { predicate_shape(:filled?) }
  let(:key_op_shape)     { { type: :key,   path: :email,    rule: filled_p_shape } }
  let(:attr_op_shape)    { { type: :attr,  path: :email,    rule: filled_p_shape } }
  let(:check_op_shape)   { { type: :check, keys: %i[email], rule: filled_p_shape } }
  let(:each_op_shape)    { { type: :each,  rule: filled_p_shape } }
  let(:not_key_op_shape) { { type: :not,   rule: key_op_shape } }
  let(:and_op_shape)     { { type: :and,   rules: [key_op_shape, filled_p_shape] } }
  let(:or_op_shape)      { { type: :or,    rules: [key_op_shape, filled_p_shape] } }
  let(:xor_op_shape)     { { type: :xor,   rules: [key_op_shape, filled_p_shape] } }
  let(:set_op_shape)     { { type: :set,   rules: [filled_p_shape] } }

  let(:enum_rule_shape) do
    { type: :and,
      rules: [predicate_shape(:type?, type: Symbol),
              predicate_shape(:included_in?, list: %i[a b c])] }
  end
end