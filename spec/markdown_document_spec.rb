require 'spec_helper'

module Stride
  RSpec.describe MarkdownDocument do
    before do
      Stride.configure do |config|
        config.client_id = 'some client id'
        config.client_secret = 'some client secret'
      end
    end

    let(:document) {
      access_token = 'access token'
      described_class.fetch!(access_token, markdown)
    }

    describe '#as_json' do
      let(:markdown) { 'hi' }

      before do
        stub_request(:post, "https://api.atlassian.com/pf-editor-service/convert?from=markdown&to=adf").
          with(body: "{\"input\":\"hi\"}",
               headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'Bearer access token', 'Content-Type'=>'application/json', 'Host'=>'api.atlassian.com', 'User-Agent'=>'Ruby'}).
          to_return(status: 200, body: {
            "version" => 1,
            "type" => "doc",
            "content" => [
              {
                "type" => "paragraph",
                "content" => [
                  {
                    "type" => "text",
                    "text" => "hi"
                  }
                ]
              }
            ]
          }.to_json, headers: {})
      end

      it 'converts into stride-friendly json' do
        expect(document.as_json).to eq(
          {
            "version" => 1,
            "type" => "doc",
            "content" => [
              {
                "type" => "paragraph",
                "content" => [
                  {
                    "type" => "text",
                    "text" => "hi"
                  }
                ]
              }
            ]
          }
        )
      end
    end
  end
end
