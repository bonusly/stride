require 'spec_helper'

module Stride
  RSpec.describe Document do
    let(:document) { described_class.new(html) }

    describe '#as_json' do
      context 'when links are included' do
        let(:html) { 'Hi from <a href="https://bonus.ly">Bonusly</a> team' }

        it 'converts converts into stride-friendly json' do
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

      context 'when emojis are included' do
        context 'in the middle' do
          let(:html) { 'Hi :smiley: team' }

          it 'converts into stride-friendly json' do
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
                        "text": "Hi "
                      },
                      {
                        "type": "emoji",
                        "attrs": {
                          "shortName": ":smiley:"
                        }
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

        context 'in the beginning' do
          let(:html) { ':smiley: Hi' }

          it 'converts into stride-friendly json' do
            expect(document.as_json).to eq(
              {
                "version": 1,
                "type": "doc",
                "content": [
                  {
                    "type": "paragraph",
                    "content": [
                      {
                        "type": "emoji",
                        "attrs": {
                          "shortName": ":smiley:"
                        }
                      },
                      {
                        "type": "text",
                        "text": " Hi"
                      }
                    ]
                  }
                ]
              }
            )
          end
        end

        context 'at the end' do
          let(:html) { 'Hi :smiley:' }

          it 'converts into stride-friendly json' do
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
                        "text": "Hi "
                      },
                      {
                        "type": "emoji",
                        "attrs": {
                          "shortName": ":smiley:"
                        }
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
  end
end
