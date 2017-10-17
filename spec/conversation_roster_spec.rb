require 'spec_helper'

module Stride
  RSpec.describe ConversationRoster do
    describe '.fetch!' do
      before do
        Stride.configure do |config|
          config.client_id     = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      context 'when successful' do
        before do
          stub_request(:get, "https://api.atlassian.com/site/cloud-id/conversation/conversation-id/roster").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
              to_return(status: 200, body: '{"values":["557058:0af0d89e-6be4-44d3-8c4c-a81b76d3c259","557058:180150a6-de73-465d-9dc7-d8577f2506db"],"_links":{"557058:0af0d89e-6be4-44d3-8c4c-a81b76d3c259":"https://api.atlassian.com/scim/site/911f7ab6-0583-4083-bed7-bad889ec4c92/Users/557058:0af0d89e-6be4-44d3-8c4c-a81b76d3c259","557058:180150a6-de73-465d-9dc7-d8577f2506db":"https://api.atlassian.com/scim/site/911f7ab6-0583-4083-bed7-bad889ec4c92/Users/557058:180150a6-de73-465d-9dc7-d8577f2506db"}}', headers: {})
        end

        let(:roster) { described_class.fetch!('access-token', 'cloud-id', 'conversation-id') }

        it 'returns a ConversationRoster' do
          expect(roster).to be_a described_class
        end

        specify { expect(roster.ids).to eq ["557058:0af0d89e-6be4-44d3-8c4c-a81b76d3c259","557058:180150a6-de73-465d-9dc7-d8577f2506db"] }
      end
    end
  end
end
