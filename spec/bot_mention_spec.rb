require 'spec_helper'

module Stride
  RSpec.describe BotMention do
    let(:json) do
      {
        "cloudId" => "cloud-id",
        "message" => {
          "id"   => "message-id",
          "body" => {
            "version" => 1,
            "type"    => "doc",
            "content" => [
              {
                "type"    => "paragraph",
                "content" => [
                  {
                    "type"  => "mention",
                    "attrs" => {
                      "id"          => "bonusly-bot-id",
                      "text"        => "@Bonusly",
                      "accessLevel" => "CONTAINER"
                    }
                  },
                  {
                    "type" => "text",
                    "text" => " +5 "
                  },
                  {
                    "type"  => "mention",
                    "attrs" => {
                      "id"          => "raphael-id",
                      "text"        => "@Raphael Crawford-Marks",
                      "accessLevel" => "CONTAINER"
                    }
                  },
                  {
                    "type" => "text",
                    "text" => " test #go-get-results"
                  }
                ]
              }
            ]
          },
          "text"   => "@Bonusly +5 @Raphael Crawford-Marks test #go-get-results",
          "sender" => {
            "id" => "sender-id"
          },
          "ts" => "2017-10-24T22:16:30.243693008Z"
        },
        "recipients" => nil,
        "sender"     => {
          "id" => "sender-id"
        },
        "conversation" => {
          "avatarUrl"  => "https://static.stride.com/default-room-avatars/web/96pt/default_07-96.png",
          "id"         => "conversation-id",
          "isArchived" => false,
          "name"       => "Bonusly Private",
          "privacy"    => "private",
          "topic"      => "Private experimentation",
          "type"       => "group",
          "modified"   => "2017-10-03T17:34:41.355Z",
          "created"    => "2017-10-03T17:33:02.453Z"
        },
        "type" => "chat_message_sent"
      }
    end

    let(:document) { described_class.new(json) }

    describe '#text' do
      it 'translates an atlassian document to plain text' do
        expect(document.text).to eq '@Bonusly +5 @Raphael Crawford-Marks test #go-get-results'
      end
    end

    describe '#text_without_mentions' do
      it 'returns the text of the message without the mentions' do
        expect(document.text_without_mentions).to eq '+5  test #go-get-results'
      end
    end

    describe '#text_with_mentions_as_user_ids' do
      it 'replaces user names with user ids' do
        expect(document.text_with_mentions_as_user_ids).to eq '@bonusly-bot-id +5 @raphael-id test #go-get-results'
      end
    end

    describe '#mentions' do
      let(:mentions) { document.mentions }

      it 'extracts all mentions' do
        expect(mentions.size).to eq 2
      end

      it 'has the text for the mentions' do
        expect(mentions.map(&:text)).to eq ['@Bonusly', '@Raphael Crawford-Marks']
      end

      it 'has the ids on the mentions' do
        expect(mentions.map(&:id)).to eq ['bonusly-bot-id', 'raphael-id']
      end

      it 'has the access levels on the mentions' do
        expect(mentions.map(&:access_level)).to eq ['CONTAINER', 'CONTAINER']
      end
    end

    describe '#sender_id' do
      it 'returns the sender id' do
        expect(document.sender_id).to eq 'sender-id'
      end
    end

    describe '#conversation' do
      it 'returns a conversation' do
        expect(document.conversation).to be_a Conversation
      end

      specify { expect(document.conversation.avatar_url).to eq "https://static.stride.com/default-room-avatars/web/96pt/default_07-96.png" }
      specify { expect(document.conversation.id).to eq "conversation-id" }
      specify { expect(document.conversation.is_archived).to eq false }
      specify { expect(document.conversation.name).to eq "Bonusly Private" }
      specify { expect(document.conversation.privacy).to eq "private" }
      specify { expect(document.conversation.topic).to eq "Private experimentation" }
      specify { expect(document.conversation.type).to eq "group" }
      specify { expect(document.conversation.modified).to eq "2017-10-03T17:34:41.355Z" }
      specify { expect(document.conversation.created).to eq "2017-10-03T17:33:02.453Z" }
    end
  end
end
