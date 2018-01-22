# Stride

A ruby wrapper for Stride's API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stride'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stride

## Configuration

Add to an initializer:

```ruby
Stride.configure do |config|
  config.client_id = "YOUR CLIENT ID"
  config.client_secret = "YOUR CLIENT SECRET"
end
```

## Usage

### Acquiring an access token

This should be done for you in most cases, but if you need to acquire an access token from the Atlassian Identity API, you may do so:

```ruby
Stride::Token.fetch!
```

This returns a `Token` instance, which will have an `access_token` attribute.

### Creating a client

Send in the cloud_id and conversation_id:

```ruby
cloud_id = '911f7ab7-0581-4082-bed3-bad889ec4c91'
conversation_id = '76987a29-b7d9-43c5-b071-7aab71d88a6b'

client = Stride::Client.new(cloud_id, conversation_id)
```

### Sending a message

If there's a specific cloud and conversation you want to send to, you can send an arbitrary message using `Stride::Client#send_message`. Refer to the [Stride API documentation](https://developer.atlassian.com/cloud/stride/blocks/message-format/) for details on the message format.

```ruby
message_body = {
  version: 1,
  type: 'doc',
  content: [
    {
      type: 'paragraph',
      content: [
        {
          type: 'text',
          text: 'I am the egg man, they are the egg men'
        }
      ]
    }
  ]
}

client.send_message(message_body)
# => {"id"=>"5d6e39d3-ab1d-10e7-be03-02420aff0003"}
```

To send a plain text message as above, there's a convience method, `Stride::Client#send_text_message`:

```ruby
client.send_message('I am the egg man, they are the egg men')
# => {"id"=>"5d6e39d3-ab1d-10e7-be03-02420aff0003"}
```

To send a message from Markdown:

```ruby
client.send_markdown_message('Oh hi [click here](https://bonus.ly)')
```

We use Atlassian's service for rendering Markdown to Atlassian Document Format (ADF).

To send a user a message:

```ruby
client.send_user_message(user_id, 'Do you have any eggs?')

client.send_user_markdown_message(user_id, 'Do you have *any* eggs?')
```

### User Details

To get details about a user when you have the id:

```ruby
client.user(user_id)
```

This returns a `User` instance with the following attributes:
`:id, :user_name, :active, :display_name, :emails, :meta, :photos`

To get details about a conversation when you have the id:

```ruby
client.conversation
```

This returns a `Conversation` instance with the following attributes:
`:cloud_id, :id, :name, :topic, :type, :created, :modified, :avatar_url, :privacy, :is_archived`

To get the members of the conversation:

```ruby
client.conversation_roster.users
```

This will return an array of `User` instances for everyone in the conversation.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stride. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stride project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stride/blob/master/CODE_OF_CONDUCT.md).
