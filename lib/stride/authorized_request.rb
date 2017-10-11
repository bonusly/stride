module Stride
  class AuthorizedRequest < BaseRequest
    private

    attr_accessor :access_token

    def headers
      {
        authorization: "Bearer #{access_token}",
        'content-type': 'application/json'
      }
    end
  end
end
