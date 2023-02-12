[![Ruby](https://github.com/estum/drymm/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/estum/drymm/actions/workflows/main.yml)

# Drym¹m² is for (¹)meta (²)mapping

Drymm represents entities provided by `Dry::Logic` & `Dry::Types` as a `Dry::Struct` classes under a `Drymm::Shapes` namespace.

The core feature of `Drymm::Shapes` is an ability to cast an AST produced by that entities and structurize it for the following serialization. Also it provides an interface to load serialized data and compile it back  the Type or Logic entity.

The casts perform by declaring expecting shapes under a specific `Drymm::Shapes::Branch` without any conditional code but with a significant amount of recursion. Shapes composed into `Dry::Struct::Sum` and handled by `Concurrent::AtomicReference` which are in front of the casting behaviour.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add drymm

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install drymm

## Usage


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/estum/drymm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/estum/drymm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Drymm project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/estum/drymm/blob/main/CODE_OF_CONDUCT.md).
