require 'redcarpet'

# Convert Markdown-formatted strings to JSON to send to Stride
# Currently only supports simple links
#
module Stride
  class MarkdownDocument
    def initialize(markdown)
      self.markdown = markdown
    end

    def as_json
      {
        "version": 1,
        "type": "doc",
        "content": [
          {
            "type": "paragraph",
            "content": content_blocks
          }
        ]
      }
    end

    private

    attr_accessor :markdown

    def content_blocks
      Redcarpet::Markdown.new(Renderer).render(markdown)
    end

    class Renderer < Redcarpet::Render::Base
      def preprocess(document)
        # make emojis look like links so we can use that hook
        document.gsub(/(\:\w+\:)/, '[\1]()')
      end

      def paragraph(text)
        text
      end

      def normal_text(text)
        {
          "type": "text",
          "text": text
        }.to_json + ','
      end

      def emphasis(text)
        # unwrap text that got passed through `normal_text`
        text = JSON.parse(text.sub(/,\Z/, ''))['text']

        {
          "type": "text",
          "text": text,
          "marks": [
            {
              "type": "strong"
            }
          ]
        }.to_json + ','
      end

      def image(link, title, alt_text)
        {
          "type": "text",
          "text": title || 'image',
          "marks": [
            {
              "type": "link",
              "attrs": {
                "href": link
              }
            }
          ]
        }.to_json + ','
      end

      def emoji_json(emoji_name)
        {
          "type": "emoji",
          "attrs": {
            "shortName": emoji_name
          }
        }.to_json + ','
      end

      def link(link, title, content)
        # unwrap text that got passed through `normal_text`
        content = JSON.parse(content.sub(/,\Z/, ''))['text']

        if link == nil && content =~ /\:\w+\:/
          emoji_json(content)
        else
          {
            "type": "text",
            "text": content,
            "marks": [
              {
                "type": "link",
                "attrs": {
                  "href": link
                }
              }
            ]
          }.to_json + ','
        end
      end

      def postprocess(document)
        # Strip lingering `!`s from image Markdown that are passed into `normal_text`
        # instead of being used to trigger the `image` hook. Not sure what's going on.
        document = document.gsub('!"},{"type":"text","text":"image"', '"},{"type":"text","text":"image"')

        # Strip leading/trailing commas
        document = document.sub(/\A,/, '').sub(/,\Z/, '')

        # Return document as JSON
        JSON.parse("[#{document}]")
      end
    end
  end
end
