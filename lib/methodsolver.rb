require "methodsolver/version"
require 'method_source'

module Methodsolver

  def self.call(&block)
    raise ArgumentError, 'no block given' unless block_given?
    begin
      Object.class_eval('def method_missing(name, *args); throw :method_missing, [self, name]; end')
      method_missing = catch :method_missing do block.call; nil end
    ensure
      Object.class_eval('remove_method :method_missing')
    end
    raise ArgumentError, 'no missing method found' unless method_missing
    object, message = method_missing
    found = methods_for(object).select do |each|
      method = object.method(each) rescue false
      begin
        method.owner.class_eval("alias #{message.inspect} #{each.inspect}")
        true === block.call
      rescue
        false
      ensure
        method.owner.class_eval("remove_method #{message.inspect}")
      end
    end
    return object, found
  end

  BLACKLIST = [:cycle]
  WHITELIST = %w(
    ! !=  == !~  <=> ===  =~ class eql? equal?
    instance_of? is_a? kind_of? hash nil? to_s
  )

  def self.methods_for(object)
    object.class.ancestors
      .unshift((object.singleton_class rescue nil)).compact
      .take_while { |cls| ![Class, Module, Object].member?(cls) }
      .flat_map { |cls| cls.instance_methods(all = false) }
      .concat(WHITELIST.map(&:to_sym))
      .-(BLACKLIST.map(&:to_sym))
      .uniq
  end

end

def solve(&block)
  object, found = Methodsolver.call(&block)
  puts "Found #{found.count} methods for #{block.source.strip rescue 'source not available'}"
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end
