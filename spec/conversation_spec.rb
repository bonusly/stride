require 'spec_helper'

module Stride
  RSpec.describe Conversation do
    describe '.fetch!' do
      before do
        Stride.configure do |config|
          config.client_id     = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      context 'when successful' do
        before do
          stub_request(:get, "https://api.atlassian.com/site/cloud-id/conversation/conversation-id").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(status: 200, body: "{\"cloudId\":\"cloud-id\",\"id\":\"conversation-id\",\"name\":\"Bonus.ly\",\"topic\":\"Applesauce\",\"type\":\"group\",\"created\":\"2017-10-03T11:19:22.261Z\",\"modified\":\"2017-10-03T11:19:22.261Z\",\"avatarUrl\":\"https://static.stride.com/default-room-avatars/web/96pt/default_08-96.png\",\"privacy\":\"public\",\"isArchived\":false,\"_links\":{\"conversation-id\":\"https://api.atlassian.com/site/cloud-id/conversation/conversation-id\"}}", headers: {})
        end

        let(:conversation) { described_class.fetch!('access-token', 'cloud-id', 'conversation-id') }

        it 'returns a Conversation' do
          expect(conversation).to be_a described_class
        end

        specify { expect(conversation.id).to eq 'conversation-id' }
        specify { expect(conversation.cloud_id).to eq 'cloud-id' }
        specify { expect(conversation.name).to eq 'Bonus.ly' }
        specify { expect(conversation.topic).to eq 'Applesauce' }
        specify { expect(conversation.type).to eq 'group' }
        specify { expect(conversation.created).to eq '2017-10-03T11:19:22.261Z' }
        specify { expect(conversation.modified).to eq '2017-10-03T11:19:22.261Z' }
        specify { expect(conversation.avatar_url).to eq 'https://static.stride.com/default-room-avatars/web/96pt/default_08-96.png' }
        specify { expect(conversation.privacy).to eq 'public' }
        specify { expect(conversation.is_archived).to eq false }
      end
    end
  end
end
