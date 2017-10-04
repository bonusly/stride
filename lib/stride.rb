require "stride/version"
require "stride/configuration"
require "stride/token"
require "stride/client"

module Stride
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
