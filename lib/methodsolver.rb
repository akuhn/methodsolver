require "methodsolver/version"
require 'method_source'

module Methodsolver

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

  def self.call(&block)
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
  object, found = Methodsolver.call(&block)
  puts "Found #{found.count} methods for #{block.source.strip}"
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end
