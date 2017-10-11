module Stride
  class Installation
    attr_accessor :key, :product_type, :cloud_id, :resource_type, :resource_id,
      :event_type, :user_id, :oauth_client_id, :version

    def self.parse(json_string)
      new(JSON.parse(json_string))
    end

    def initialize(json)
      self.key             = json['key']
      self.product_type    = json['productType']
      self.cloud_id        = json['cloudId']
      self.resource_type   = json['resourceType']
      self.resource_id     = json['resourceId']
      self.event_type      = json['eventType']
      self.user_id         = json['userId']
      self.oauth_client_id = json['oauthClientId']
      self.version         = json['version']
    end
  end
end
