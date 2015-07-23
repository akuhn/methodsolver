require 'methodsolver'

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  words.___ == 'the'
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  words.___(%w(fox dog)) == %w(the quick brown jumps over the lazy)
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  Numeric === words.___
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  Hash === words.___(&:itself)
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  %(the quick brown fox jumps over the lazy dog).___ == words
}

solve {
  words = %w(the quick brown fox jumps over the lazy dog)
  %w(the quick brown fox).___ %w(jumps over the lazy dog) == words
}

solve {
  'hello'.___ == 'Hello'
}

solve {
  Math::PI.___ == 3
}

solve {
  3.41.___ == 3 && -3.41.___ == -3
}

solve {
  ''.___ == String
}

solve {
  'hello'.___ == 'olleh'
}

solve {
  'example.rb'.___('.rb') == 'example'
}

solve {
  'example.rb'.___('example') == '.rb'
}

solve {
  /aura/.___('restaurant')
}

solve {
  1.___(10) == 1..10
}
