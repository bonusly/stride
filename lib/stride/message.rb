module Stride
  class Message
    def initialize(access_token, cloud_id, conversation_id, message_body)
      self.access_token    = access_token
      self.cloud_id        = cloud_id
      self.conversation_id = conversation_id
      self.message_body    = message_body
    end

    def send!
      Request.new(access_token, cloud_id, conversation_id, message_body).json
    end

    private

    attr_accessor :access_token, :cloud_id, :conversation_id, :message_body

    class Request < BaseRequest
      def initialize(access_token, cloud_id, conversation_id, message_body)
        self.access_token           = access_token
        self.cloud_id        = cloud_id
        self.conversation_id = conversation_id
        self.message_body    = message_body
      end

      private

      attr_accessor :access_token, :cloud_id, :conversation_id, :message_body

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/site/#{cloud_id}/conversation/#{conversation_id}/message"
        )
      end

      def params
        message_body
      end

      def headers
        {
          authorization: "Bearer #{access_token}",
          'content-type': 'application/json'
        }
      end
    end
  end
end
