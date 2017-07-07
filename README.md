# Orthodox

Replacement Rails generators for Katana apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'orthodox', github: "katana/orthodox"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install orthodox

## Usage

An empty controller:

    rails g controller users

A controller with prepopulated actions:

    rails g controller users new create show

A controller with actions and authentication:

    rails g controller users new create show --authenticate admin

A controller with a namespace:

    rails g controller admins/users new create show --authenticate admin


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/KatanaCode/orthodox.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
