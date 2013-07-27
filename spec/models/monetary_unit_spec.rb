require 'spec_helper'

describe MonetaryUnit do
  let(:monetary_unit) { create :monetary_unit }

  describe '#to_s' do
    it 'is an alias for monetary_unit_code' do
      monetary_unit.to_s.should eq monetary_unit.monetary_unit_code
    end
  end
end
