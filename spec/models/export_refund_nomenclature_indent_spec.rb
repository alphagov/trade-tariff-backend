require 'rails_helper'

describe ExportRefundNomenclatureIndent do
  let(:erni)  { build :export_refund_nomenclature_indent }

  describe '#number_indents' do
    subject { erni.number_indents }
    it 'is an alias for number_export_refund_nomenclature_indents' do
      is_expected.to eq erni.number_export_refund_nomenclature_indents
    end
  end
end
