require 'spec_helper'

RSpec.describe Stride do
  describe '.configuration' do
    it 'returns a non nil object' do
      described_class.configuration = nil

      expect(described_class.configuration).to_not be nil
    end
  end

  describe '.configure' do
    before do
      described_class.configure do |config|
        config.client_id     = 'some client id'
        config.client_secret = 'some client secret'
      end
    end

    it 'returns sets Stride.configuration' do
      expect(Stride.configuration).to be_a Stride::Configuration
    end

    it 'sets client_id' do
      expect(Stride.configuration.client_id).to eq 'some client id'
    end

    it 'sets client_secret' do
      expect(Stride.configuration.client_secret).to eq 'some client secret'
    end

    it 'defaults production to true' do
      expect(Stride.configuration.production?).to be true
    end
  end
end
