require 'spec_helper'

module Stride
  RSpec.describe UserMessage do
    describe '.send!' do
      before do
        Stride.configure do |config|
          config.client_id     = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      let(:message_body) do
        {
          version: 1,
          type: 'doc',
          content: [
            {
              type: 'paragraph',
              content: [
                {
                  type: 'text',
                  text: 'I am the egg man, they are the egg men'
                }
              ]
            }
          ]
        }
      end

      let(:message) do
        described_class.new(
          'token', 1, 2, message_body
        )
      end

      context 'when successful' do
        before do
          stub_request(:post, 'https://api.atlassian.com/site/1/conversation/user/2/message').
            with(
              body: "{\"version\":1,\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"I am the egg man, they are the egg men\"}]}]}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer token', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(status: 201, body: '{"id":"message-id"}', headers: {})
        end

        let(:message_response) { message.send! }

        it 'returns some json' do
          expect(message_response).to eq({ 'id' => 'message-id' })
        end
      end

      context 'when failed' do
        before do
          stub_request(:post, 'https://api.atlassian.com/site/1/conversation/user/2/message').
            with(
              body: "{\"version\":1,\"type\":\"doc\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"I am the egg man, they are the egg men\"}]}]}",
              headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer token', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}
            ).to_return(
              status: 403,
              body: '{"error":"access denied or something"}',
              headers: {}
            )
        end

        it 'throws an exception' do
          expect {
            message.send!
          }.to raise_error ApiFailure
        end
      end
    end
  end
end
