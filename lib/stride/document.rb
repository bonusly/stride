require 'nokogiri'

# Convert HTML to JSON to send to Stride
# Currently only supports simple links
#
module Stride
  class Document
    def initialize(html)
      self.html = html
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

    attr_accessor :html

    def content_blocks
      nokogiri_elements.flat_map { |element| ElementJson.new(element).as_json }
    end

    def nokogiri_elements
      # document > html > body > p > children
      nokogiri_doc.children.children.children.children
    end

    def nokogiri_doc
      Nokogiri::HTML(html)
    end

    class ElementJson
      def initialize(nokogiri_element)
        self.nokogiri_element = nokogiri_element
      end

      def as_json
        case nokogiri_element
        when Nokogiri::XML::Text then text_element
        else                          link_element
        end
      end

      private

      attr_accessor :nokogiri_element

      def text_element
        text = nokogiri_element.text

        if emoji?
          emoji_element
        elsif contains_emoji?
          text_and_emoji_elements
        else
          {
            "type": "text",
            "text": nokogiri_element.text
          }
        end
      end

      def emoji?
        nokogiri_element.text =~ /\A\:\w+\:\Z/
      end

      def emoji_element
        {
          "type": "emoji",
          "attrs": {
            "shortName": nokogiri_element.text
          }
        }
      end

      def contains_emoji?
        nokogiri_element.text =~ /\:\w+\:/
      end

      def text_and_emoji_elements
        components = nokogiri_element.text.match(/(.*)(\:\w+\:)(.*)/)

        [components[1], components[2], components[3]].select { |string| string != '' }.map do |component|
          nokogiri_text = Nokogiri::XML::Text.new(component, Nokogiri::XML::Document.new)
          self.class.new(nokogiri_text).as_json
        end
      end

      def link_element
        {
          "type": "text",
          "text": nokogiri_element.text,
          "marks": [
            {
              "type": "link",
              "attrs": {
                "href": nokogiri_element.attributes['href'].value
              }
            }
          ]
        }
      end
    end
  end
end
