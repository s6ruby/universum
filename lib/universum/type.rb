# encoding: utf-8


## add dummy bool class for mapping and (payable) method signature

class Integer
  def self.zero() 0; end
end

class Bool
  def self.zero() false; end
end

class Money
  def self.zero() 0; end
end

class Void   ## only used (reserved) for (payable) method signature now
end


class Mapping

  def self.of( *args )
     ## e.g. gets passed in [{Address=>Integer}]
     ##  check for Integer - use Hash.new(0)
     ##  check for Bool    - use Hash.new(False)
     if args[0].is_a? Hash
       arg = args[0].to_a   ## convert to array (for easier access)
       klass_key   = arg[0][0]
       klass_value = arg[0][1]
       klass = SafeHash.build_class( klass_key, klass_value )
       klass.new
     else
       ## todo/fix: throw argument error/exception
       Hash.new    ## that is, "plain" {} with all "standard" defaults
     end
  end
end


class Array
  ## "typed" safe array "constructor"
  ## e.g.  Array.of( Address ) or Array.of( Money ) or Array.of( Proposal, size: 2 ) etc.
  def self.of( klass_value )
    klass = SafeArray.build_class( klass_value )
    klass.new  ## todo: add klass.new( **kwargs ) for size: 2 etc.
  end
end
