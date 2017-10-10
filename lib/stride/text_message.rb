module Stride
  class TextMessage
    def initialize(access_token, cloud_id, conversation_id, message_text)
      self.access_token    = access_token
      self.cloud_id        = cloud_id
      self.conversation_id = conversation_id
      self.message_text    = message_text
    end

    def send!
      Message.new(access_token, cloud_id, conversation_id, message_body).send!
    end

    private

    attr_accessor :access_token, :cloud_id, :conversation_id, :message_text

    def message_body
      {
        version: 1,
        type: 'doc',
        content: [
          {
            type: 'paragraph',
            content: [
              {
                type: 'text',
                text: message_text
              }
            ]
          }
        ]
      }
    end
  end
end
