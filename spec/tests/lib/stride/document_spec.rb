require 'spec_helper'

module Stride
  RSpec.describe Document do
    let(:document) do
      described_class.new('Hi from <a href="https://bonus.ly">Bonusly</a> team')
    end

    describe '#as_json' do
      it 'converts html into stride-formatted documents' do
        expect(document.as_json).to eq(
          {
            "version": 1,
            "type": "doc",
            "content": [
              {
                "type": "paragraph",
                "content": [
                  {
                    "type": "text",
                    "text": "Hi from "
                  },
                  {
                    "type": "text",
                    "text": "Bonusly",
                    "marks": [
                      {
                        "type": "link",
                        "attrs": {
                          "href": "https://bonus.ly"
                        }
                      }
                    ]
                  },
                  {
                    "type": "text",
                    "text": " team"
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
