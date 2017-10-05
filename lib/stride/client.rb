module Stride
  class Client

    def send_message(cloud_id, conversation_id, message_body)
      Message.new(token.access_token, cloud_id, conversation_id, message_body).send!
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
