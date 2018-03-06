require 'spec_helper'

module Stride
  RSpec.describe Me do
    describe '.fetch!' do
      before do
        Stride.configure do |config|
          config.client_id     = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      context 'when successful' do
        before do
          stub_request(:get, "https://api.atlassian.com/me").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(status: 200, body: "{\"account_id\":\"bot-account-id\",\"name\":\"Bonusly\",\"email\":\"bot-email@connect.atlassian.com\",\"picture\":\"https://avatar-cdn.atlassian.com/bot-picture?by=hash\"}", headers: {})
        end

        let(:me) { described_class.fetch!('access-token') }

        it 'fetches and parses a user' do
          expect(me).to be_a described_class
        end

        specify { expect(me.account_id).to eq 'bot-account-id' }
        specify { expect(me.name).to eq 'Bonusly' }
        specify { expect(me.email).to eq 'bot-email@connect.atlassian.com' }
        specify { expect(me.picture).to eq 'https://avatar-cdn.atlassian.com/bot-picture?by=hash' }
      end

      context 'when failed' do
        before do
          stub_request(:get, "https://api.atlassian.com/me").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(
              status: 403,
              body: '{"error":"access denied or something"}',
              headers: {}
            )
        end

        it 'throws an exception' do
          expect {
            described_class.fetch!('access-token')
          }.to raise_error ApiFailure
        end
      end
    end
  end
end
