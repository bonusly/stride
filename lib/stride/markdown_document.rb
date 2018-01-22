module Stride
  class MarkdownDocument
    def initialize(request)
      self.request = request
    end

    def self.fetch!(access_token, markdown)
      new(Request.new(access_token, markdown))
    end

    def as_json
      request.json
    end

    private

    attr_accessor :request

    class Request < AuthorizedRequest
      def initialize(access_token, markdown)
        self.access_token = access_token
        self.markdown     = markdown
      end

      def uri
        URI(
          "#{Stride.configuration.api_base_url}/pf-editor-service/convert?from=markdown&to=adf"
        )
      end

      def params
        {
          input: markdown
        }
      end

      private

      attr_accessor :markdown
    end
  end
end
