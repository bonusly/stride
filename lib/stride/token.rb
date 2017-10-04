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

    class Request
      def json
        if result.code == '200'
          JSON.parse(result.body)
        else
          raise ApiFailure.new("Could not get token: #{result.inspect}")
        end
      end

      private

      def result
        @result ||= Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
      end

      def request
        Net::HTTP::Post.new(uri).tap do |req|
          req.set_form_data(params)
        end
      end

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

  class ApiFailure < RuntimeError; end
end
