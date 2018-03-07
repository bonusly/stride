require 'stride/version'
require 'stride/configuration'
require 'stride/atlassian_document_format_expander'
require 'stride/base_request'
require 'stride/authorized_request'
require 'stride/token'
require 'stride/message'
require 'stride/user_message'
require 'stride/text_message'
require 'stride/client'
require 'stride/installation'
require 'stride/user'
require 'stride/markdown_document'
require 'stride/conversation'
require 'stride/conversation_roster'
require 'stride/bot_mention'
require 'stride/me'

module Stride
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
