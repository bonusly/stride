require "stride/version"
require "stride/configuration"
require "stride/base_request"
require "stride/authorized_request"
require "stride/token"
require "stride/message"
require "stride/text_message"
require "stride/client"
require "stride/installation"
require "stride/user"
require "stride/markdown_document"

module Stride
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
