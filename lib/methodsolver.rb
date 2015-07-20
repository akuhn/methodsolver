require "methodsolver/version"
require 'method_source'

module Methodsolver

  def self.call(&block)
    raise ArgumentError, 'no block given' unless block_given?
    begin
      Object.class_eval('def method_missing(name, *args); throw :reciever, [self, name]; end')
      object, message = catch :reciever, &block
    ensure
      Object.class_eval('remove_method :method_missing')
    end
    raise ArgumentError, 'no unknown method found' unless message
    found = methods_for(object).select do |each|
      begin
        object.class.class_eval("alias #{message.inspect} #{each.inspect}")
        true === block.call
      rescue
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
  object, found = Methodsolver.call(&block)
  puts "Found #{found.count} methods for #{block.source.strip}"
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end
