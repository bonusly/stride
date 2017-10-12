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
      nokogiri_elements.map { |element| ElementJson.new(element).to_s }
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

      def to_s
        case nokogiri_element
        when Nokogiri::XML::Text then text_element
        else                          link_element
        end
      end

      private

      attr_accessor :nokogiri_element

      def text_element
        {
          "type": "text",
          "text": nokogiri_element.text
        }
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
