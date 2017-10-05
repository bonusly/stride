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

### Sending a message

If there's a specific cloud and conversation you want to send to, you can send an arbitrary message using `Stride::Client#send_message`.

```ruby
cloud_id = '911f7ab7-0581-4082-bed3-bad889ec4c91'
conversation_id = '76987a29-b7d9-43c5-b071-7aab71d88a6b'

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

Stride::Client.new.send_message(cloud_id, conversation_id, message_body)
# => {"id"=>"5d6e39d3-ab1d-10e7-be03-02420aff0003"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/stride. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stride project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/stride/blob/master/CODE_OF_CONDUCT.md).
