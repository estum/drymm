# frozen_string_literal: true

require "dry/logic/predicates"

RSpec.shared_context "with logic predicates" do
  let(:nil?) { Dry::Logic::Predicates[:nil?] }

  let(:array?) { Dry::Logic::Predicates[:array?] }

  let(:empty?) { Dry::Logic::Predicates[:empty?] }

  let(:str?) { Dry::Logic::Predicates[:str?] }

  let(:true?) { Dry::Logic::Predicates[:true?] }

  let(:hash?) { Dry::Logic::Predicates[:hash?] }

  let(:int?) { Dry::Logic::Predicates[:int?] }

  let(:filled?) { Dry::Logic::Predicates[:filled?] }

  let(:min_size?) { Dry::Logic::Predicates[:min_size?] }

  let(:lt?) { Dry::Logic::Predicates[:lt?] }

  let(:gt?) { Dry::Logic::Predicates[:gt?] }

  let(:key?) { Dry::Logic::Predicates[:key?] }

  let(:attr?) { Dry::Logic::Predicates[:attr?] }

  let(:eql?) { Dry::Logic::Predicates[:eql?] }

  let(:size?) { Dry::Logic::Predicates[:size?] }

  let(:case?) { Dry::Logic::Predicates[:case?] }

  let(:equal?) { Dry::Logic::Predicates[:equal?] }
end
