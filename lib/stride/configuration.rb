module Stride
  class Configuration
    attr_accessor :client_id, :client_secret, :production

    def initialize
      self.production = true
    end

    def api_base_url
      production? ? 'https://api.atlassian.com' : 'https://api.stg.atlassian.com'
    end

    def api_audience
      production? ? 'api.atlassian.com' : 'api.stg.atlassian.com'
    end

    def auth_api_base_url
      production? ? 'https://auth.atlassian.com' : 'https://atlassian-account-stg.pus2.auth0.com'
    end

    def production?
      !!production
    end
  end
end
