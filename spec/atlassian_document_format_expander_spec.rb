require 'spec_helper'

module Stride
  RSpec.describe AtlassianDocumentFormatExpander do
    let(:expander) { described_class.new(initial_json) }

    describe '#json' do
      context 'when nothing should be expanded' do
        let(:initial_json) do
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
        end

        it 'just returns it' do
          expect(expander.json).to eq initial_json
        end
      end

      context 'when doing weird mention markup' do
        context 'mention in the middle of text' do
          let(:initial_json) do
            {
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "text",
                      "text" => "hi @@Bonusly|ab123@@ how you doing"
                    }
                  ]
                }
              ]
            }
          end

          it 'splits it out into a mention' do
            expect(expander.json).to eq ({
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "text",
                      "text" => "hi "
                    },
                    {
                      "type" => "mention",
                      "attrs" => {
                        "id"          => "ab123",
                        "text"        => "@Bonusly",
                        "accessLevel" => "CONTAINER"
                      }
                    },
                    {
                      "type" => "text",
                      "text" => " how you doing"
                    }
                  ]
                }
              ]
            })
          end
        end

        context 'mention at the beginning of text' do
          let(:initial_json) do
            {
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "text",
                      "text" => "@@Bonusly|ab123@@ how you doing"
                    }
                  ]
                }
              ]
            }
          end

          it 'splits it out into a mention' do
            expect(expander.json).to eq ({
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "mention",
                      "attrs" => {
                        "id"          => "ab123",
                        "text"        => "@Bonusly",
                        "accessLevel" => "CONTAINER"
                      }
                    },
                    {
                      "type" => "text",
                      "text" => " how you doing"
                    }
                  ]
                }
              ]
            })
          end
        end

        context 'mention at the end of text' do
          let(:initial_json) do
            {
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "text",
                      "text" => "hi @@Bonusly|ab123@@"
                    }
                  ]
                }
              ]
            }
          end

          it 'splits it out into a mention' do
            expect(expander.json).to eq ({
              "version" => 1,
              "type" => "doc",
              "content" => [
                {
                  "type" => "paragraph",
                  "content" => [
                    {
                      "type" => "text",
                      "text" => "hi "
                    },
                    {
                      "type" => "mention",
                      "attrs" => {
                        "id"          => "ab123",
                        "text"        => "@Bonusly",
                        "accessLevel" => "CONTAINER"
                      }
                    }
                  ]
                }
              ]
            })
          end
        end
      end
    end
  end
end
