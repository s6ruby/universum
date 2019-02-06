# encoding: utf-8

class SafeArray

  def initialize( klass )
    @type = klass
    @ary  = []
  end

  def [](index)
    item = @ary[ index ]
    item = @type.zero  if item.nil?
    item
  end

  def push( item )
    ## todo/fix: check if item.is_a? @type
    ##   note: Address might be a String too (Address | String)
    ##     store Address always as String!!! - why? why not?
    @ary.push( item )
  end

end # class SafeArray
