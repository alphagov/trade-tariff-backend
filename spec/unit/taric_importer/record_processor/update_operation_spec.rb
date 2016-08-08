require "rails_helper"

describe TaricImporter::RecordProcessor::UpdateOperation do

  describe "#call" do

  end

  describe "#to_oplog_operation" do
    it "identifies as update operation" do
      empty_operation = TaricImporter::RecordProcessor::UpdateOperation.new(nil, nil)
      expect(empty_operation.to_oplog_operation).to eq :update
    end
  end
end
