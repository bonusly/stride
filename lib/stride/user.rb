module Stride
  class User
    attr_accessor :id, :user_name, :active, :display_name, :emails, :meta, :photos

    def initialize(json)
      self.id           = json['id']
      self.user_name    = json['userName']
      self.active       = json['active']
      self.display_name = json['displayName']
      self.emails       = json['emails'].map { |email| Email.new(email['value'], email['primary']) }
      self.meta         = json['meta']
      self.photos       = json['photos'].map { |photo| Photo.new(photo['value'], photo['primary']) }
    end

    def self.fetch!(access_token, cloud_id, user_id)
      new(UserRequest.new(access_token, cloud_id, user_id).json)
    end

    def primary_email
      emails.detect { |email| email.primary? }&.value
    end

    private

    Email = Struct.new(:value, :primary) do
      def primary?
        primary
      end
    end

    Photo = Struct.new(:url, :primary) do
      def primary?
        primary
      end
    end

    class UserRequest < AuthorizedRequest
      def initialize(access_token, cloud_id, user_id)
        self.access_token = access_token
        self.cloud_id     = cloud_id
        self.user_id      = user_id
      end

      private

      attr_accessor :cloud_id, :user_id

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/scim/site/#{cloud_id}/Users/#{user_id}"
        )
      end

      def request_class
        Net::HTTP::Get
      end
    end
  end
end
