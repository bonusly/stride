module Stride
  class Client

    # `message_body` is a formatted message in JSON
    # See: https://developer.atlassian.com/cloud/stride/blocks/message-format/
    def send_message(cloud_id, conversation_id, message_body)
      Message.new(token.access_token, cloud_id, conversation_id, message_body).send!
    end

    # Convenience method for sending a plain text message
    def send_text_message(cloud_id, conversation_id, message_text)
      TextMessage.new(token.access_token, cloud_id, conversation_id, message_text).send!
    end

    private

    def token
      return @token if have_token?

      @token = Token.fetch!
    end

    def have_token?
      @token.present? && @token.unexpired?
    end
  end
end
