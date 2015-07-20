# Methodsolver

Finds ruby methods given a block with placeholder.

For example:

```ruby
solve { 'lettuce'.foo == 7 }
```

Will find `#length` and `#size`

## Installation

Clone this repo and run pry:

    git clone https://github.com/akuhn/methodsolver.git
    cd methodsolver
    bundle
    bundle exec pry

And then execute:

```ruby
require 'methodsolver'
solve { 'lettuce'.foo == 7 }
```

Please refer to `examples/solve.rb` (and the rspec tests) for more examples.

## Usage

Use with caution!

The solver attempts to executes the block with arbitrary methods found on the reciever. Beware of side effects. Append the symbol of dangerous methods to `Methodsolver::BLACKLIST` in order to blacklist them.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akuhn/methodsolver.

