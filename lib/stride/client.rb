module Stride
  class Client

    private

    def token
      return @token if have_token?

      @token = Token.fetch!
    end

    def have_token?
      @token.present? && @token.unexpired?
    end
  end
end
