# Note 👷

**This repository is at the forefront of development work.** 🚧

# AutoSeed

Automatically generate records from ActiveRecord models. It is for development and staging.

If you want dummy data in database, it help you. 🍊

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'auto_seed'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install auto_seed

## Usage

In your db/seeds.rb:

```ruby
require 'auto_seed'
AutoSeed::Sower.new.sow_all
```

And then execute:

    $ rails db:seed

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/basicinc/auto_seed.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

