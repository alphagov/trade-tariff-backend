require 'spec_helper'
require 'chief_transformer'
require 'active_support/log_subscriber/test_helper'

describe ChiefTransformer::Logger do
  include ActiveSupport::LogSubscriber::TestHelper

  before {
    setup # ActiveSupport::LogSubscriber::TestHelper.setup

    ChiefTransformer::Logger.attach_to :chief_transformer
    ChiefTransformer::Logger.logger = @logger
  }

  describe '#start_transform logging' do
    before { ChiefTransformer.instance.invoke }

    it 'logs an info event' do
      @logger.logged(:info).size.should be >= 1
      @logger.logged(:info).first.should =~ /CHIEF Transformer started/
    end
  end

  describe '#transform logging' do
    before { ChiefTransformer.instance.invoke }

    context 'successuful transformation' do
      it 'logs and info event' do
        @logger.logged(:info).size.should be >= 1
        @logger.logged(:info).last.should =~ /finished successfull/
      end
    end

    context 'transformation with errors' do
      before {
        ChiefTransformer::Processor.expects(:new)
                                   .raises(ChiefTransformer::TransformException)

        rescuing { ChiefTransformer.instance.invoke }
      }

      it 'logs an error event' do
        @logger.logged(:error).size.should eq 1
        @logger.logged(:error).last.should =~ /transformer failed/i
      end
    end
  end

  describe '#process logging' do
    let!(:tame) { create :tame }

    context 'successful process' do
      before { ChiefTransformer.instance.invoke }

      it 'logs an info event' do
        @logger.logged(:info).size.should be >= 1
        @logger.logged(:info)[1].should =~ /processed/i
      end
    end
  end

  describe '#exception logging' do
    let!(:tame) { create :tame }

    before {
      tame.expects(:mark_as_processed!).raises(StandardError)

      rescuing { ChiefTransformer::Processor.new([tame]).process }
    }

    it 'logs an error event' do
      @logger.logged(:error).size.should eq 1
      @logger.logged(:error).last.should =~ /Could not transform/i
    end
  end
end
