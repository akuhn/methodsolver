require 'methodsolver'

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  words.foo == 'the'
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  words.foo(%w(fox dog)) == %w(the quick brown jumps over the lazy)
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  Numeric === words.foo
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  Hash === words.foo(&:itself)
}

solve {
  %(the quick brown fox jumps over the lazy dog).foo == words
}

solve {
  %w(the quick brown fox).foo %w(jumps over the lazy dog) == words
}

solve {
  'hello'.foo == 'Hello'
}

solve {
  Math::PI.foo == 3
}

solve {
  3.41.foo == 3 && -3.41.foo == -3
}

solve {
  ''.foo == String
}

solve {
  'hello'.foo == 'olleh'
}

solve {
  'example.rb'.foo('.rb') == 'example'
}

solve {
  'example.rb'.foo('example') == '.rb'
}

solve {
  /aura/.foo('restaurant')
}

solve {
  1.foo(10) == 1..10
}
