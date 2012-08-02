require 'spec_helper'

describe Api::V1::SearchController, "POST #search" do
  describe 'exact matching' do
    let(:chapter) { create :chapter }
    let(:pattern) {
      {
        type: 'exact_match',
        entry: {
          endpoint: 'chapters',
          id: chapter.to_param
        }
      }
    }

    before {
      post :search, { q: chapter.to_param, as_of: chapter.validity_start_date }
    }

    it { should respond_with(:success) }
    it 'returns exact match endpoint and indetifier if query for exact record' do
        response.body.should match_json_expression pattern
    end
  end

  describe 'fuzzy matching', :focus do
    let(:chapter) { create :chapter, :with_description }
    let(:pattern) {
      {
        type: 'exact_match',
        entry: {
          endpoint: 'chapters',
          id: chapter.to_param
        }
      }
    }

    before {
      Tire.stubs(:search).returns(TireStub)

      post :search, { q: chapter.description,  as_of: chapter.validity_start_date }
    }

    it { should respond_with(:success) }
    it 'returns exact match endpoint and indetifier if query for exact record' do
    end
  end

  describe 'errors' do
    let(:pattern) {
      {
        q: Array,
        as_of: Array
      }
    }

    before {
      post :search
    }

    it { should respond_with(:success) }
    it 'returns list of errors' do
        response.body.should match_json_expression pattern
    end
  end
end