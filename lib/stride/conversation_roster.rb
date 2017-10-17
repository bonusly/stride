module Stride
  class ConversationRoster
    attr_accessor :access_token, :cloud_id, :ids

    def self.fetch!(access_token, cloud_id, conversation_id)
      new(access_token, cloud_id, Request.new(access_token, cloud_id, conversation_id).json)
    end

    def initialize(access_token, cloud_id, json)
      self.access_token = access_token
      self.cloud_id     = cloud_id
      self.ids          = json['values']
    end

    def users
      @users ||= ids.map { |id| User.fetch!(access_token, cloud_id, id) }
    end

    private

    class Request < AuthorizedRequest
      def initialize(access_token, cloud_id, conversation_id)
        self.access_token    = access_token
        self.cloud_id        = cloud_id
        self.conversation_id = conversation_id
      end

      private

      attr_accessor :cloud_id, :conversation_id

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/site/#{cloud_id}/conversation/#{conversation_id}/roster"
        )
      end

      def request_class
        Net::HTTP::Get
      end
    end
  end
end
