module Stride
  class Conversation
    attr_accessor :cloud_id, :id, :name, :topic, :type, :created, :modified,
      :avatar_url, :privacy, :is_archived

    def self.fetch!(access_token, cloud_id, conversation_id)
      new(Request.new(access_token, cloud_id, conversation_id).json)
    end

    def initialize(json)
      self.id          = json['id']
      self.cloud_id    = json['cloudId']
      self.name        = json['name']
      self.topic       = json['topic']
      self.type        = json['type']
      self.created     = json['created']
      self.modified    = json['modified']
      self.avatar_url  = json['avatarUrl']
      self.privacy     = json['privacy']
      self.is_archived = json['isArchived']
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
          "#{Stride.configuration.api_base_url}/site/#{cloud_id}/conversation/#{conversation_id}"
        )
      end

      def request_class
        Net::HTTP::Get
      end
    end
  end
end
