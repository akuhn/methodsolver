require 'methodsolver'

words = %w(the quick brown fox jumps over the lazy dog)

solve {
  words.dup.foo == 'the'
}

solve {
  words.dup.foo(%w(fox dog)) == %w(the quick brown jumps over the lazy)
}

solve {
  Numeric === words.dup.foo
}

solve {
  Hash === words.dup.foo(&:itself)
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
