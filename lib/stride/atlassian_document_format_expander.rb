module Stride
  class AtlassianDocumentFormatExpander
    def initialize(initial_json)
      self.initial_json = initial_json
    end

    def as_json
      return initial_json unless initial_json.has_key?('content')

      initial_json['content'] = ContentBlocks.new(initial_json['content']).as_json
      initial_json
    end

    private

    attr_accessor :initial_json

    class ContentBlocks
      def initialize(initial_json)
        self.initial_json = initial_json
      end

      def as_json
        wrapped_blocks.map(&:as_json).flatten
      end

      private

      attr_accessor :initial_json

      def wrapped_blocks
        initial_json.map do |content_block_json|
          if content_block_json.has_key?('content')
            content_block_json['content'] = ContentBlocks.new(content_block_json['content']).as_json
            content_block_json
          else
            ContentBlock.new(content_block_json)
          end
        end
      end
    end

    class ContentBlock
      MENTION_REGEX = /@@([a-zA-Z]+)\|([a-zA-Z0-9\-:]+)@@/
      MENTION_REGEX_WITHOUT_GROUPS = /@@[a-zA-Z]+\|[a-zA-Z0-9\-:]+@@/

      def initialize(initial_json)
        self.initial_json = initial_json
      end

      def as_json
        split? ? split_json : initial_json
      end

      private

      attr_accessor :initial_json

      def split?
        initial_json.has_key?('text') && match_data.present?
      end

      def match_data
        @match_data ||= initial_json['text'].match(MENTION_REGEX)
      end

      def split_json
        split_blocks.map(&:as_json)
      end

      def split_blocks
        return text_blocks_joined_by_mention_block if mention_in_middle?

        if mention_at_beginning?
          text_blocks_joined_by_mention_block.prepend mention_block
        else
          text_blocks_joined_by_mention_block << mention_block
        end
      end

      def text_blocks_joined_by_mention_block
        @text_blocks_joined_by_mention_block ||= text_blocks.each_with_object([]) do |text_block, all_blocks|
          all_blocks << text_block
          all_blocks << mention_block unless text_block == text_blocks.last
        end.reject { |block| block.as_json['text'] == '' }
      end

      def mention_in_middle?
        text_blocks_joined_by_mention_block.count > 1
      end

      def mention_at_beginning?
        (initial_json['text'] =~ MENTION_REGEX_WITHOUT_GROUPS) == 0
      end

      def text_blocks
        @text_blocks ||= initial_json['text'].split(MENTION_REGEX_WITHOUT_GROUPS).map do |text|
          self.class.new({
            "type" => "text",
            "text" => text
          })
        end
      end

      def mention_block
        @mention_block ||= self.class.new({
          "type" => "mention",
          "attrs" => {
            "id"          => match_data[2],
            "text"        => "@#{match_data[1]}",
            "accessLevel" => "CONTAINER"
          }
        })
      end
    end
  end
end
