require 'methodsolver'

solve {
  h = { a: 1, bunny: 2, c: 3 }
  h.______(:bunny)
  h.keys == [:a, :c]
}


puts "Find common elements of arrays:"
solve { [1,2,3]._____([2,3,4]) == [2,3] }


puts "Check object equality:"
solve {
  obj = %w(a bunny c d e)
  obj.___(obj) == true && obj.___(%w(a bunny c d e)) == true
}


puts "Check object identity:"
solve {
  obj = %w(a bunny c d e)
  obj.___(obj) == true && obj.___(%w(a bunny c d e)) == false
}


puts "Remove file extension if present:"
solve {
  'example.rb'._____('.rb') == 'example' &&
  'example'._____('.rb') == 'example'
}


puts "Find file extension:"
solve {
  'example.rb'._____('.rb') == true &&
  'example'._____('.rb') == false
}


puts "Write as proper noun:"
solve { 'bunny'._____ == 'Bunny' }


puts "What's left after division:"
solve { 65._____(7) == 2 }


puts "Add default values to hash:"
solve {
  h = { a: 1, b: 2, c: 3 }
  h = h._____(b: 'bunny', d: 4)
  h[:b] == 2 && h[:d] == 4
}


puts "Add new values to hash:"
solve {
  h = { a: 1, b: 2, c: 3 }
  h = h._____(b: 'bunny', d: 4)
  h[:b] == 'bunny' && h[:d] == 4
}


puts "Turn list of words into list of chars:"
solve { %w(a bb ccc)._____(&:chars) == %w(a b b c c c) }


puts "Combine two arrays:"
solve { %w(a bb ccc)._____(%w(xx yy)) == %w(a bb ccc xx yy) }


puts "Which enumerations turn arrays into hashes?"
solve { Hash === %w(aa bb cc)._____(&:itself) }


puts "Remove element:"
solve {
  a = %w(a bunny c d e)
  a = a._____('bunny')
  a.size == 4
}


puts "Split into words:"
solve { 'aa bb cc'._____(' ').member? 'aa' }


puts "Remove all occurrences:"
solve { 'a bb ccc'._____(' ') == 'abbccc' }


puts "Replace all occurrences:"
solve { 'a bb ccc'._____(' ', '+') == 'a+bb+ccc' }


puts "Is element in array?"
solve { 'bunny'._____(%w(a bunny c d e)) }


puts "Does array contain element?"
solve { %w(a bunny c d e)._____('bunny') }


puts "Split an array into pairs?"
solve {
  pairs = %w(a b c d e f)._____(2)
  pairs.map(&:size).uniq == [2]
}


# Fun with enumerations ...

def words
  %w(this array has five words)
end

puts "Which enum is like a map?"
solve {
  words._____{ |each| each.size } == [4, 5, 3, 4, 5]
}

puts "Which enum is like a fold?"
solve {
  words._____{ |a, b| a.swapcase + b } == 'thisARRAYhasFIVEwords'
}

puts "Which enum is like a filter?"
solve {
  words._____{ |each| each.size == 5 } == %w(array words)
}

puts "And is there an inverse filter?"
solve {
  words._____{ |each| each.size == 5 } == %w(this has five)
}

puts "Which enum finds the first match?"
solve {
  words._____{ |each| each.size == 5 } == 'array'
}

puts "Which enum finds the shortest word?"
solve {
  words._____{ |each | each.size } == 'has'
}

puts "Can we use an enum for splitting?"
solve {
  groups = %w(a b b b c c)._____{ |a, b| a != b }
  groups.map(&:size) == [1, 3, 2]
}
