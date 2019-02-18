# encoding: utf-8

require 'pp'

#######
# keep track of contract state

class Storage

  def initialize
    @storage = {}
  end

  def [](key)
    puts "Storage#[](#{key})"
    @storage[key]
  end

  def []=(key,value)
    puts "Storage#[]=(#{key}, #{value})"
    @storage[key] = value
  end


  def method_missing( m, *args, &block )
    puts "Storage#method_missing( #{m.inspect}), #{args.inspect} )"

    ## todo: add support ? for bool
    ##    elsif m.end_with?('?') && args.empty?
    ##      @storage[m]

    if m[-1] == '=' && args.size == 1
      key = m[0...-1].to_sym    ## note: cut-off trailing equal sign (=), use EXCLUSIVE (...) range and NOT INCLUSIVE (..)
      puts "  SSTORE( #{key.inspect}, #{args[0].inspect} )"
      @storage[key] = args[0]
    elsif m =~/\A[a-z][a-zA-Z0-9_]*\z/ && args.empty?   ## todo/fix: check for valid identifier
      key = m
      puts "  SLOAD( #{key.inspect} )"
      @storage[key]
    else
      super
    end
  end

end ## class Storage


s = Storage.new
s[:balance]
s[:balance] = {}
s[:balance]['0xaaaa'] = 100
s[:balance]['0xbbbb'] = 200

pp s
pp s.balance
pp s.owner     = '0x1111'
pp s.owner
pp s.balance['0xcccc'] = 300
pp s.balance?
