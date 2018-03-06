module Stride
  class Me
    attr_accessor :account_id, :name, :email, :picture

    def self.fetch!(access_token)
      new(MeRequest.new(access_token).json)
    end

    def initialize(json)
      self.account_id = json['account_id']
      self.name       = json['name']
      self.email      = json['email']
      self.picture    = json['picture']
    end

    private

    class MeRequest < AuthorizedRequest
      def initialize(access_token)
        self.access_token = access_token
      end

      private

      attr_accessor :cloud_id, :user_id

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/me"
        )
      end

      def request_class
        Net::HTTP::Get
      end
    end
  end
end
