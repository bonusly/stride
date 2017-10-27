module Stride
  class BotMention
    def initialize(json)
      self.json = json
    end

    def text
      json['message']['text']
    end

    def text_without_mentions
      content_blocks.select(&:text?).map(&:text).join.strip
    end

    def mentions
      content_blocks.select(&:mention?)
    end

    def sender_id
      json['sender']['id']
    end

    def conversation
      Conversation.new(json['conversation'])
    end

    def text_with_mentions_as_user_ids
      content_blocks.map { |block| block.respond_to?(:at_id) ? block.at_id : block.text }.join.strip
    end

    private

    attr_accessor :json

    def content_blocks
      ContentBlock.wrap(json['message']['body']['content'].first)
    end

    class ContentBlock
      def self.wrap(json)
        json = json['content'] if json.has_key?('content')
        json.map { |json_block| factory(json_block) }
      end

      def self.factory(json_block)
        json_block['type'] == 'text' ? TextBlock.new(json_block) : MentionBlock.new(json_block)
      end

      def initialize(json)
        self.json = json
      end

      def type
        json['type']
      end

      def text?
        false
      end

      def mention?
        false
      end

      private

      attr_accessor :json
    end

    class TextBlock < ContentBlock
      def text
        json['text']
      end

      def text?
        true
      end
    end

    class MentionBlock < ContentBlock
      def text
        attrs['text']
      end

      def id
        attrs['id']
      end

      def access_level
        attrs['accessLevel']
      end

      def mention?
        true
      end

      def at_id
        "@#{id}"
      end

      private

      def attrs
        json['attrs']
      end
    end
  end
end
