RSpec.shared_context 'types shapes' do
  include_context 'logic shapes'

  let(:any_shape) { { type: :any, meta: {} } }

  let(:array_shape) { { type: :array, member: any_shape, meta: {} } }

  let(:str_class) { { type: :const, name: 'String' } }

  let(:sym_class) { { type: :const, name: 'Symbol' } }

  let(:n_str_shape) { { type: :nominal, base: str_class, meta: {} } }

  let(:n_sym_shape) { { type: :nominal, base: sym_class, meta: {} } }

  let(:c_sym_fn) { { type: :id, id: t::Coercible::Symbol.fn.to_ast[1] } }

  let(:c_sym_shape) { { type: :constructor, base: n_sym_shape, fn: c_sym_fn } }

  let(:sum_shape) { { type: :sum, left: n_str_shape, right: n_sym_shape, meta: {} } }

  let(:impl_shape) { { type: :implication, left: n_str_shape, right: c_sym_shape, meta: {} } }

  let(:inter_shape) { { type: :intersection, left: n_str_shape, right: c_sym_shape, meta: {} } }

  let(:constr_shape) { { type: :constrained, base: n_str_shape, rule: filled_p_shape } }

  let(:enum_base_shape) { { type: :constrained, base: n_sym_shape, rule: enum_rule_shape } }

  let(:enum_shape) { { type: :enum, base: enum_base_shape, mapping: { a: :a, b: :b, c: :c } } }

  let(:hash_shape) { { type: :hash, options: {}, meta: {} } }

  let(:lax_shape) { { type: :lax, base: c_sym_shape } }

  let(:key_shape) { { type: :key, name: :name, required: true, base: any_shape } }

  let(:schema_shape) { { type: :schema, keys: [key_shape], options: {}, meta: {} } }

  let(:map_shape) { { type: :map, key_type: n_sym_shape, value_type: n_str_shape, meta: {} } }
end