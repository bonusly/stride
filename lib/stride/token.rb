module Stride
  class Token
    attr_accessor :access_token, :refresh_time

    def self.fetch!
      new(Request.new.json)
    end

    def initialize(json)
      self.access_token = json['access_token']
      self.refresh_time = Time.now + json['expires_in']
    end

    def unexpired?
      Time.now < refresh_time
    end

    private

    class Request < BaseRequest

      private

      def uri
        @uri ||= URI(Stride.configuration.auth_api_base_url + '/oauth/token')
      end

      def params
        {
          grant_type:    'client_credentials',
          client_id:     Stride.configuration.client_id,
          client_secret: Stride.configuration.client_secret,
          audience:      Stride.configuration.api_audience
        }
      end
    end
  end
end
