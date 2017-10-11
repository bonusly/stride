require 'spec_helper'

module Stride
  RSpec.describe Installation do
    describe '.parse' do
      let(:installation) do
        described_class.parse(
         '{"key": "bonusly-test-key",
          "productType": "chat",
          "cloudId": "912f7ac6-1583-4183-eed7-bad889ec4c91",
          "resourceType": "conversation",
          "resourceId": "81d7e44b-60c1-49d0-631e-a05c42633461",
          "eventType": "installed",
          "userId": "557051:5fc0562c-1f26-4cad-bf44-b195aa53bf3e",
          "oauthClientId": "3qXdHCZ5K8PDLyKyYIwdyGne5X2vZFfB",
          "version": "1"}'
        )
      end

      specify { expect(installation.key).to eq 'bonusly-test-key' }
      specify { expect(installation.product_type).to eq 'chat' }
      specify { expect(installation.cloud_id).to eq '912f7ac6-1583-4183-eed7-bad889ec4c91' }
      specify { expect(installation.resource_type).to eq 'conversation' }
      specify { expect(installation.resource_id).to eq '81d7e44b-60c1-49d0-631e-a05c42633461' }
      specify { expect(installation.event_type).to eq 'installed' }
      specify { expect(installation.user_id).to eq '557051:5fc0562c-1f26-4cad-bf44-b195aa53bf3e' }
      specify { expect(installation.oauth_client_id).to eq '3qXdHCZ5K8PDLyKyYIwdyGne5X2vZFfB' }
      specify { expect(installation.version).to eq '1' }
    end
  end
end
