require "methodsolver/version"
require 'method_source'

module Methodsolver

  def self.call(options = {}, &block)
    raise ArgumentError, 'no block given' unless block_given?

    # Detect missing method, ie placeholder:

    begin
      Object.class_eval('def method_missing(name, *args); throw :undefined_method, [self, name]; end')
      receiver, placeholder = catch :undefined_method do
        block.call
        raise ArgumentError, 'no missing method found'
      end
    ensure
      Object.class_eval('remove_method :method_missing')
    end

    somewhat_limited_safety_checks(receiver, block) unless options[:unsafe]

    # Find methods that pass the block:

    results = methods_for(receiver).select do |name|
      method = receiver.method(name) rescue next
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
      { receiver: receiver, placeholder: placeholder, results: results }
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
      .reject { |name| name =~ /[=!]$/ }
      .concat(WHITELIST)
      .-(BLACKLIST)
      .uniq
  end

  SAVE = [Array, Fixnum, Float, Hash, Object, Range, Regexp, String]

  def self.somewhat_limited_safety_checks(receiver, block)
    return if receiver.nil?
    block.binding.eval('local_variables').each do |name|
      if receiver.equal? block.binding.eval("#{name} rescue nil")
        receiver.clone rescue break # omit warning for immutables
        raise ArgumentError,
          "receiver equals local variable '#{name}', " <<
          "use solve(unsafe: true) or clone/dup the variable"
      end
    end
    unless SAVE.include? receiver.class
      raise ArgumentError,
        "class of receiver not marked as save: #{receiver.class}, " <<
        "use solve(unsafe: true) or append to Methodsolver::SAVE"
    end
  end

end

def solve(options = {}, &block)
  data = Methodsolver.call(options.merge(metadata: true), &block)
  object, found = data[:receiver], data[:results]
  if block.respond_to? :method_source
    puts "Found #{found.count} methods for #{block.method_source.strip}"
  else
    puts "Found #{found.count} methods for ##{data[:placeholder]}"
  end
  found.map do |symbol|
    method = object.method(symbol)
    puts "- #{method.owner}\e[32m##{method.name}\e[0m"
  end
  puts
end
