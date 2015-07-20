# Find Ruby methods
require 'method_source'

module Methodfinder

  # Patch NoMethodError#reciever

  NoMethodError.class_eval('attr_accessor :reciever')
  Object.class_eval("""
    def method_missing(*args)
      begin
        super
      rescue NoMethodError => ex
        ex.reciever = self
        raise ex
      end
    end
  """)

  def self.solve(&block)
    raise ArgumentError, 'no block given' unless block_given?
    begin
      block.call
    rescue NoMethodError => ex
      object = ex.reciever
      message = ex.name
    end
    raise ArgumentError, 'no unknown method found' unless message
    found = methods_for(object).select do |each|
      begin
        object.class.class_eval("alias #{message.inspect} #{each.inspect}")
        true === block.call
      rescue => ex
        false
      ensure
        object.class.class_eval("remove_method #{message.inspect}")
      end
    end
    return object, found
  end

  BLACKLIST = [:cycle]

  def self.methods_for(object)
    object.class.ancestors
      .take_while { |a| Object != a }
      .flat_map { |a| a.instance_methods(all = false) }
      .concat(%w(
        ! !=  == !~  <=> ===  =~ class eql? equal?
        instance_of? is_a? kind_of? hash nil? to_s
      ))
      .map(&:to_sym)
      .uniq
      .- BLACKLIST
  end

end

def solve(&block)
  object, found = Methodfinder.solve(&block)
  puts "Found #{found.count} methods for #{block.source}"
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end

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
  %w(a bb ccc).foo(&:chars) == %w(a b b c c c)
}
