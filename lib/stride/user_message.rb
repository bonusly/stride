module Stride
  class UserMessage
    def initialize(access_token, cloud_id, user_id, message_body)
      self.access_token = access_token
      self.cloud_id     = cloud_id
      self.user_id      = user_id
      self.message_body = message_body
    end

    def send!
      Request.new(access_token, cloud_id, user_id, message_body).json
    end

    private

    attr_accessor :access_token, :cloud_id, :user_id, :message_body

    class Request < AuthorizedRequest
      def initialize(access_token, cloud_id, user_id, message_body)
        self.access_token = access_token
        self.cloud_id     = cloud_id
        self.user_id      = user_id
        self.message_body = message_body
      end

      private

      attr_accessor :cloud_id, :user_id, :message_body

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/site/#{cloud_id}/conversation/user/#{user_id}/message"
        )
      end

      def params
        message_body
      end
    end
  end
end
