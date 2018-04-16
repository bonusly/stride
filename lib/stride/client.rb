module Stride
  class Client
    def initialize(cloud_id, conversation_id, permanent_token = nil)
      self.cloud_id        = cloud_id
      self.conversation_id = conversation_id
      self.permanent_token = permanent_token
    end

    # `message_body` is a formatted message in JSON
    # See: https://developer.atlassian.com/cloud/stride/blocks/message-format/
    def send_message(message_body)
      Message.new(access_token, cloud_id, conversation_id, message_body).send!
    end

    # Convenience method for sending a plain text message
    def send_text_message(message_text)
      TextMessage.new(access_token, cloud_id, conversation_id, message_text).send!
    end

    def send_user_message(user_id, message_body)
      UserMessage.new(access_token, cloud_id, user_id, message_body).send!
    end

    def send_user_markdown_message(user_id, markdown)
      send_user_message(user_id, MarkdownDocument.fetch!(access_token, markdown).as_json)
    end

    def send_markdown_message(markdown)
      send_message(MarkdownDocument.fetch!(access_token, markdown).as_json)
    end

    def user(user_id)
      User.fetch!(access_token, cloud_id, user_id)
    end

    def conversation
      Conversation.fetch!(access_token, cloud_id, conversation_id)
    end

    def conversation_roster
      ConversationRoster.fetch!(access_token, cloud_id, conversation_id)
    end

    def me
      Me.fetch!(access_token)
    end

    private

    attr_accessor :cloud_id, :conversation_id, :permanent_token

    def access_token
      permanent_token || token.access_token
    end

    def token
      return @token if have_token?

      @token = Token.fetch!
    end

    def have_token?
      !@token.nil? && @token.unexpired?
    end
  end
end
