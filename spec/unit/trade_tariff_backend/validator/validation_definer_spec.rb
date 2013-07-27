require 'spec_helper'

describe TradeTariffBackend::Validator::ValidationDefiner do
  describe '.generic_validation_klass' do
    it 'defaults to GenericValidation' do
      described_class.generic_validation_klass.should eq TradeTariffBackend::Validations::GenericValidation
    end
  end

  describe '.define' do
    context 'no block given' do
      it 'raises ArgumentError' do
        expect { described_class.define('validation description', {}) }.to raise_error ArgumentError
      end
    end

    context 'block without arguments given' do
      context 'validation evaluated' do
        it 'returns instance of validation' do
          described_class.define(:vld1, 'inclusion validation', {}) {
            validates :inclusion, of: [:abc]
          }.should be_kind_of TradeTariffBackend::Validations::InclusionValidation
        end
      end

      context 'validation not evaluated' do
        it 'raises ArgumentErorr' do
          expect {
            described_class.define('inclusion validation', {}) {
              # noop here
            }
          }.to raise_error ArgumentError
        end
      end
    end

    context 'block with argument given' do
      it 'returns generic validation instance' do
        described_class.define(:vld1, 'generic_validation', {}) { |record| }.should be_kind_of described_class.generic_validation_klass
      end
    end
  end

  describe '#validates' do
    let(:validation) { described_class.new('validation', {}) { } }

    before { validation.validates(:validation_type, {a: :b}) }

    it 'assigns validation type' do
      validation.validation_type.should eq :validation_type
    end

    it 'assigns validation options' do
      validation.validation_options.should eq Hash[:a, :b]
    end
  end

  describe '#validation' do
    context 'validation type set' do
      it 'returns instance of validation' do
          described_class.new('inclusion validation', {}) {
            validates :inclusion, of: [:a]
          }.validation.should  be_kind_of TradeTariffBackend::Validations::InclusionValidation
      end
    end

    context 'validation type not set' do
      it 'raises ArgumentError' do
        expect {
          described_class.new('inclusion validation', {}) {
            # noop here
          }.validation
        }.to raise_error ArgumentError
      end
    end
  end
end
