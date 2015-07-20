# Find Ruby methods

module Methodfinder

  def self.call(object, options = {})
    args = [*options[:args]]
    block = options[:block]
    expected = options[:match]

    methods(object).collect do |symbol|
      next if :cycle === symbol
      begin
        args_copy = Marshal.load(Marshal.dump(args))
        object_copy = Marshal.load(Marshal.dump(object))
        result = object_copy.send(symbol, *args_copy, &block)
        [symbol, args, result] if expected === result
      rescue
        nil
      end
    end.compact
  end

  private

  def self.methods(object)
    object.class.ancestors
      .take_while { |a| Object != a }
      .flat_map { |a| a.instance_methods(all = false) }
      .concat %w(! !=  == !~  <=> ===  =~ eql? equal? )
      .concat %w(hash instance_of? is_a? kind_of? nil? to_s)
      .map(&:to_sym)
      .uniq
  end

end

class Object

  def find_methods(options = {})
    Methodfinder.call(self, options).map(&:first).uniq
  end

  def print_methods(options = {})
    found = Methodfinder.call(self, options)
    puts "Found #{found.count} methods"
    found.map do |symbol, args, result|
      method = self.method(symbol)
      params = "(#{args.map(&:inspect).join(', ')})" unless args.empty?
      print "- #{method.owner}\e[32m##{method.name}\e[0m#{params}"
      print " => " << result.inspect unless result == options[:match]
      puts
    end
    puts
  end

end

words = %w(the quick brown fox jumps over the lazy dog)

words.print_methods(match: 'the')

words.print_methods(match: Numeric)

words.print_methods(block: :itself, match: Hash)

%(the quick brown fox jumps over the lazy dog).print_methods(match: words)

%w(the quick brown fox).print_methods(args: [%w(jumps over the lazy dog)], match: words)

'hello'.print_methods(match: 'Hello')

Math::PI.print_methods(match: 3)
