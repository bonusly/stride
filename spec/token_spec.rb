require 'spec_helper'

module Stride
  RSpec.describe Token do
    describe '.fetch!' do
      before do
        Stride.configure do |config|
          config.client_id = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      context 'when successful' do
        before do
          stub_request(:post, "https://auth.atlassian.com/oauth/token").
            with(
              body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"some client id\",\"client_secret\":\"some client secret\",\"audience\":\"api.atlassian.com\"}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'auth.atlassian.com', 'User-Agent'=>'Ruby'}
            ).to_return(
              status: 200,
              body: '{"access_token":"some access token","scope":"participate:conversation manage:conversation","expires_in":3600,"token_type":"Bearer"}',
              headers: {}
            )
        end


        let(:token) { described_class.fetch! }

        it 'fetches and parses a token' do
          expect(token).to be_a described_class
        end

        it 'has an access token' do
          expect(token.access_token).to eq 'some access token'
        end

        it 'is unexpired' do
          expect(token).to be_unexpired
        end
      end

      context 'when failed' do
        before do
          stub_request(:post, "https://auth.atlassian.com/oauth/token").
            with(
              body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"some client id\",\"client_secret\":\"some client secret\",\"audience\":\"api.atlassian.com\"}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'auth.atlassian.com', 'User-Agent'=>'Ruby'}
            ).to_return(
              status: 403,
              body: '{"error":"access denied or something"}',
              headers: {}
            )
        end

        it 'throws an exception' do
          expect {
            described_class.fetch!
          }.to raise_error ApiFailure
        end
      end
    end
  end
end
