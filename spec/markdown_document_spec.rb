require 'spec_helper'

module Stride
  RSpec.describe MarkdownDocument do
    let(:document) { described_class.new(markdown) }

    describe '#as_json' do
      context 'plain text' do
        let(:markdown) { 'hi' }

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

      context 'with bolded text' do
        let(:markdown) { 'hi *bob*' }

        it 'converts it into stride-friendly json' do
          expect(document.as_json).to eq(
            {
              "version": 1,
              "type": "doc",
              "content": [
                {
                  "type": "paragraph",
                  "content": [
                    {
                      "type" => "text",
                      "text" => "hi "
                    },
                    {
                      "type" => "text",
                      "text" => "bob",
                      "marks" => [
                        {
                          "type" => "strong"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          )
        end
      end

      context 'when links are included' do
        let(:markdown) { 'Hi from [Bonusly team](https://bonus.ly) okay!' }

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
                      "type" => "text",
                      "text" => "Hi from "
                    },
                    {
                      "type" => "text",
                      "text" => "Bonusly team",
                      "marks" => [
                        {
                          "type" => "link",
                          "attrs" => {
                            "href" => "https://bonus.ly"
                          }
                        }
                      ]
                    },
                    {
                      "type" => "text",
                      "text" => " okay!"
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
          let(:markdown) { 'Hi :smiley: team' }

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
                        "type" => "text",
                        "text" => "Hi "
                      },
                      {
                        "type" => "emoji",
                        "attrs" => {
                          "shortName" => ":smiley:"
                        }
                      },
                      {
                        "type" => "text",
                        "text" => " team"
                      }
                    ]
                  }
                ]
              }
            )
          end
        end

        context 'in the beginning' do
          let(:markdown) { ':smiley: Hi' }

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
                        "type"=>"text",
                        "text"=>""
                      },
                      {
                        "type" => "emoji",
                        "attrs" => {
                          "shortName" => ":smiley:"
                        }
                      },
                      {
                        "type" => "text",
                        "text" => " Hi"
                      }
                    ]
                  }
                ]
              }
            )
          end
        end

        context 'at the end' do
          let(:markdown) { 'Hi :smiley:' }

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
                        "type" => "text",
                        "text" => "Hi "
                      },
                      {
                        "type" => "emoji",
                        "attrs" => {
                          "shortName" => ":smiley:"
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

      context 'when markdown images are included' do
        let(:markdown) { 'oh hi ![](https://media2.giphy.com/media/dtBi0s3hndz7q/giphy-downsized.gif)' }

        it 'turns them into a link' do
          expect(document.as_json).to eq(
            {
              "version": 1,
              "type": "doc",
              "content": [
                {
                  "type": "paragraph",
                  "content": [
                    {
                      "type" => "text",
                      "text" => "oh hi "
                    },
                    {
                      "type" => "text",
                      "text" => "image",
                      "marks" => [
                        {
                          "type" => "link",
                          "attrs" => {
                            "href" => "https://media2.giphy.com/media/dtBi0s3hndz7q/giphy-downsized.gif"
                          }
                        }
                      ]
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
