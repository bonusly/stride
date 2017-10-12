module Stride
  class Client

    # `message_body` is a formatted message in JSON
    # See: https://developer.atlassian.com/cloud/stride/blocks/message-format/
    def send_message(cloud_id, conversation_id, message_body)
      Message.new(access_token, cloud_id, conversation_id, message_body).send!
    end

    # Convenience method for sending a plain text message
    def send_text_message(cloud_id, conversation_id, message_text)
      TextMessage.new(access_token, cloud_id, conversation_id, message_text).send!
    end

    # Converts messages with HTML links to Stride-friendly messages
    def send_message_from_html(cloud_id, conversation_id, html)
      document = Document.new(html)
      send_message(cloud_id, conversation_id, document.as_json)
    end

    def get_user(cloud_id, user_id)
      User.fetch!(access_token, cloud_id, user_id)
    end

    private

    def access_token
      token.access_token
    end

    def token
      return @token if have_token?

      @token = Token.fetch!
    end

    def have_token?
      @token.present? && @token.unexpired?
    end
  end
end
