require "methodsolver/version"
require 'method_source'

module Methodsolver

  def self.call(options = {}, &block)
    raise ArgumentError, 'no block given' unless block_given?

    # Detect missing method, ie placeholder:

    begin
      Object.class_eval('def method_missing(name, *args); throw :undefined_method, [self, name]; end')
      reciever, placeholder = catch :undefined_method do
        block.call
        raise ArgumentError, 'no missing method found'
      end
    ensure
      Object.class_eval('remove_method :method_missing')
    end

    # Find methods that pass the block:

    results = methods_for(reciever).select do |name|
      method = reciever.method(name) rescue next
      begin
        method.owner.class_eval("alias #{placeholder.inspect} #{name.inspect}")
        true === block.call
      rescue
        false
      ensure
        method.owner.class_eval("remove_method #{placeholder.inspect}")
      end
    end

    # Optionally return a hash with metadata:

    if options[:metadata]
      { reciever: reciever, placeholder: placeholder, results: results }
    else
      results
    end
  end

  private

  BLACKLIST = [
    :cycle,
  ]
  WHITELIST = [
    :'!', :'!=', :'!~', :'<', :'<=', :'<=>', :'==', :'===', :'=~', :'>', :'>=',
    :class, :eql?, :equal?, :hash, :instance_of?, :is_a?, :itself, :kind_of?,
    :nil?, :respond_to?, :tap, :to_s,
  ]

  def self.methods_for(object)
    object.class.ancestors
      .take_while { |cls| ![Class, Module, Object].member?(cls) }
      .flat_map { |cls| cls.instance_methods(all = false) }
      .concat(object.singleton_methods)
      .reject { |name| name =~ /=$/ }
      .concat(WHITELIST)
      .-(BLACKLIST)
      .uniq
  end

end

def solve(&block)
  data = Methodsolver.call(metadata: true, &block)
  object, found = data[:reciever], data[:results]
  puts "Found #{found.count} methods for #{block.source.strip rescue 'source not available'}"
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end
