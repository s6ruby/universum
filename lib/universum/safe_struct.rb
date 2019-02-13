# encoding: utf-8

class SafeStruct

def self.build_class( **attributes )
  klass = Class.new( SafeStruct ) do
    define_method( :initialize ) do |*args|
      attributes.keys.zip( args ).each do |key, arg|
        instance_variable_set( "@#{key}", arg )
      end
    end

    attributes.keys.each do |key|
      define_method( key ) do
        instance_variable_get( "@#{key}" )
      end
      define_method( "#{key}=" ) do |value|
        instance_variable_set( "@#{key}", value )
      end
    end
  end

  ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
  klass.define_singleton_method( :new ) do |*args|
    old_new( *args )
  end

  klass.define_singleton_method( :new_zero ) do
    old_new( *attributes.values )
  end

  klass
end # method build_class

class << self
  alias_method :old_new, :new       # note: store "old" orginal version of new
  alias_method :new,     :build_class    # replace original version with create
end

def self.zero
  @zero ||= new_zero
end
end # class SafeStruct


############################
# note: HACK redefine built in struct
#  => warning: already initialized constant Struct
OldStruct = Struct        ## save old struct class
Struct    = SafeStruct


