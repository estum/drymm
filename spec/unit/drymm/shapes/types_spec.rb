# frozen_string_literal: true

module Drymm::Shapes
  RSpec.describe Types do
    subject(:shape_branch) { Types }

    let(:t) { Dry.Types() }

    describe '.sum' do
      subject(:sum) { shape_branch.sum }
      it { is_expected.to be_instance_of(Dry::Struct::Sum) }
    end

    include_context 'types shapes'

    describe Types::Any do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Any]' do
        let(:input) { t::Any }
        let(:output) { any_shape }
      end
    end

    describe Types::Array do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Array<Any>]' do
        let(:input) { t.Array(t::Any).type }
        let(:output) { array_shape }
      end
    end

    xdescribe Types::CoercibleArray do
    end

    xdescribe Types::CoercibleHash do
    end

    describe Types::Composition do
      xcontext 'implication' do
        it_behaves_like 'bidirectional shape', 'Dry::Types[Implication] (A > B)' do
          let(:input) { t::Nominal::String > t::Coercible::Symbol }
          let(:output) { impl_shape }
        end
      end

      xcontext 'intersection' do
        it_behaves_like 'bidirectional shape', 'Dry::Types[Intersection] (A & B)' do
          let(:input) { t::Nominal::String & t::Coercible::Symbol }
          let(:output) { inter_shape }
        end
      end

      it_behaves_like 'bidirectional shape', 'Dry::Types[Sum] (A | B)' do
        let(:input) { t::Nominal::String | t::Nominal::Symbol }
        let(:output) { sum_shape }
      end
    end

    describe Types::Constrained do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Constrained]' do
        let(:input) { t::Nominal::String.constrained(filled: true) }
        let(:output) { constr_shape }
      end
    end

    describe Types::Constructor do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Constructor]' do
        let(:input) { t::Coercible::Symbol }
        let(:output) { c_sym_shape }
      end
    end

    describe Types::Enum do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Enum]' do
        let(:input) { t::Symbol.enum(:a, :b, :c) }
        let(:output) { enum_shape }
      end
    end

    describe Types::Hash do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Hash]' do
        let(:input) { t::Nominal::Hash }
        let(:output) { hash_shape }
      end
    end

    describe Types::Nominal do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Nominal]' do
        let(:input) { t::Nominal::String }
        let(:output) { n_str_shape }
      end
    end

    describe Types::Lax do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Lax]' do
        let(:input) { t::Coercible::Symbol.lax }
        let(:output) { lax_shape }
      end
    end

    describe Types::Key do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Key]' do
        let(:input) { described_class.schema.keys[1] }
        let(:output) { key_shape }
      end
    end

    describe Types::Schema do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Schema]' do
        let(:input) { t::Hash(name: t::Any).type }
        let(:output) { schema_shape }
      end
    end

    describe Types::Map do
      it_behaves_like 'bidirectional shape', 'Dry::Types[Map]' do
        let(:input) { t.Map(t::Nominal::Symbol, t::Nominal::String) }
        let(:output) { map_shape }
      end
    end
  end
end
