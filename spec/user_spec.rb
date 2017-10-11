require 'spec_helper'

module Stride
  RSpec.describe User do
    describe '.fetch!' do
      before do
        Stride.configure do |config|
          config.client_id     = 'some client id'
          config.client_secret = 'some client secret'
        end
      end

      context 'when successful' do
        before do
          stub_request(:get, "https://api.atlassian.com/scim/site/cloud-id/Users/user-id").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(status: 200, body: "{\"schemas\":[\"urn:ietf:params:scim:schemas:core:2.0:User\"],\"id\":\"user-id\",\"userName\":\"jon@bonus.ly\",\"active\":true,\"displayName\":\"Jon Evans\",\"emails\":[{\"value\":\"jon@bonus.ly\",\"primary\":true}],\"meta\":{\"created\":\"2017-10-03T11:18:10.815Z\",\"lastModified\":\"2017-10-03T14:14:35.735Z\",\"resourceType\":\"User\"},\"photos\":[{\"primary\":true,\"value\":\"https://avatar-cdn.atlassian.com/someidentifier\"}]}", headers: {})
        end

        let(:user) { described_class.fetch!('access-token', 'cloud-id', 'user-id') }

        it 'fetches and parses a user' do
          expect(user).to be_a described_class
        end

        specify { expect(user.id).to eq 'user-id' }
        specify { expect(user.user_name).to eq 'jon@bonus.ly' }
        specify { expect(user.active).to eq true }
        specify { expect(user.display_name).to eq 'Jon Evans' }
        specify { expect(user.emails).to eq [User::Email.new('jon@bonus.ly', true)] }
        specify { expect(user.meta).to be_a Hash }
        specify { expect(user.photos).to eq [User::Photo.new('https://avatar-cdn.atlassian.com/someidentifier', true)] }
      end

      context 'when failed' do
        before do
          stub_request(:get, "https://api.atlassian.com/scim/site/cloud-id/Users/user-id").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access-token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
            to_return(
              status: 403,
              body: '{"error":"access denied or something"}',
              headers: {}
            )
        end

        it 'throws an exception' do
          expect {
            described_class.fetch!('access-token', 'cloud-id', 'user-id')
          }.to raise_error ApiFailure
        end
      end
    end
  end
end
