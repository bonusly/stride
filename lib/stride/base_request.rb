module Stride
  class BaseRequest
    def json
      if result.code =~ /20\d/
        JSON.parse(result.body)
      else
        raise ApiFailure.new(error_message)
      end
    end

    private

    def result
      @result ||= Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
    end

    def error_message
      "Got a #{result.code} from Stride API: #{result.body}"
    end

    def request
      request_class.new(uri).tap do |req|
        req.body = params.to_json if params.any?
        headers.each do |key, value|
          req[key] = value
        end
      end
    end

    def request_class
      Net::HTTP::Post
    end

    def uri
      raise 'uri must be implemented per request'
    end

    def params
      {}
    end

    def headers
      {
        'content-type' => 'application/json'
      }
    end
  end

  class ApiFailure < RuntimeError; end
end
