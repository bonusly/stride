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
          expect(expander.as_json).to eq initial_json
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
            expect(expander.as_json).to eq ({
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
            expect(expander.as_json).to eq ({
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
            expect(expander.as_json).to eq ({
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

  RSpec.describe AtlassianDocumentFormatExpander::ContentBlock do
    let(:content_block) { described_class.new(initial_json) }

    context 'when nothing to split' do
      let(:initial_json) do
        {
          "type" => "text",
          "text" => "hi"
        }
      end

      it 'returns the initial json' do
        expect(content_block.as_json).to eq initial_json
      end
    end

    context 'when things to split' do
      let(:initial_json) do
        {
          "type" => "text",
          "text" => "hi @@Bonusly|ab123@@ sup"
        }
      end

      it 'returns the appropriate json' do
        expect(content_block.as_json).to eq([
          {
            "type" => "text",
            "text" => "hi "
          },
          {
            "type" => "mention",
            "attrs" => {
              "id" => "ab123",
              "text" => "@Bonusly",
              "accessLevel" => "CONTAINER"
            }
          },
          {
            "type" => "text",
            "text" => " sup"
          }
        ])
      end
    end
  end
end
