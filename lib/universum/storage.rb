# encoding: utf-8

#######
# keep track of contract state

class Storage

  def initialize
    @data = {}
  end

  def [](key)
    puts "Storage#[](#{key})"
    @data[key]
  end

  def []=(key,value)
    puts "Storage#[]=(#{key}, #{value})"
    @data[key] = value
  end



  ###############################
  # todo/future: in the future auto-add getter/setter methods on setup
  #   do NOT use method_missing!!!
  def method_missing( m, *args, &block )
    puts "Storage#method_missing( #{m.inspect}), #{args.inspect} )"

    ## todo: add support ? for bool
    ##    elsif m.end_with?('?') && args.empty?
    ##      @storage[m]

    if m =~/\A[a-z][a-zA-Z0-9_]*=\z/ && args.size == 1
      key   = m[0...-1].to_sym    ## note: cut-off trailing equal sign (=), use EXCLUSIVE (...) range and NOT INCLUSIVE (..)
      value = args[0]
      puts "  SSTORE( #{key.inspect}, #{value.inspect} )"
      @data[key] = value
    elsif m =~/\A[a-z][a-zA-Z0-9_]*\z/ && args.empty?   ## todo/fix: check for valid identifier
      key = m
      puts "  SLOAD( #{key.inspect} )"
      @data[key]
    else
      super
    end
  end

end ## class Storage
