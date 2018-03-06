module Stride
  class AtlassianDocumentFormatExpander
    def initialize(initial_json)
      self.initial_json = initial_json
    end

    def json
      # return initial_json unless initial_json.is_a?(Hash÷)
      initial_json
    end

    private

    attr_accessor :initial_json
  end
end
