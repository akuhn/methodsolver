# Methodsolver

Finds ruby methods given a block with placeholder.

For example:

```ruby
solve { 'lettuce'.foo == 7 }
```

Will find `#length` and `#size`

Use with caution and beware of side effects!

The solver attempts to executes the block with arbitrary methods found on the reciever. Append the symbol of dangerous methods to `Methodsolver::BLACKLIST` in order to blacklist them.

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akuhn/methodsolver.

