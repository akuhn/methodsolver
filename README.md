# Methodsolver

Finds ruby methods given a block with placeholder.

For example:

```ruby
solve {
  h = { a: 1, bunny: 2, c: 3 }
  h.______(:bunny)
  h.keys == [:a, :c]
}
```

Will find `#delete`

Use with caution!

Beware of side effects. The solver attempts to execute the block with arbitrary methods found on the receiver. Append the symbol of dangerous methods to `Methodsolver::BLACKLIST` in order to blacklist them. Setters and bang methods are blacklisted by default.

## Usage

Please refer to [`examples/examples.rb`](examples/examples.rb) (and the rspec tests) for more examples.

## Installation

Get this gem:

    gem install methodsolver

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akuhn/methodsolver.

