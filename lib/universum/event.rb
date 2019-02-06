# encoding: utf-8

##################################
## auto-create/builds struct-like class.
##
## Example:
##   Roll = Event.new( :id, :rolled )
##     auto-creates/builds:
##
##   class Event; end
##   class Roll < Event
##     def initialize( id, rolled )
##       @id     = id
##       @rolled = rolled
##     end
##
##     def id()     @id; end
##     def rolled() @rolled; end
##   end
##
##   pp roll = Roll.new( 1, 2345 )   #=> #<Roll @id=1, @rolled=2345>
##   pp roll.id                      #=> 1
##   pp roll.rolled                  #=> 2345


## base class for events
class Event
  ## return a new Struct-like read-only class

  ###################
  ##  meta-programming "macro" - build class (on the fly)
  ##
  def self.build_class( *fields )
    klass = Class.new( Event ) do
      define_method( :initialize ) do |*args|
        fields.zip( args ).each do |field, arg|
          instance_variable_set( "@#{field}", arg )
        end
      end

      fields.each do |field|
        define_method( field ) do
          instance_variable_get( "@#{field}" )
        end
      end
    end

    ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
    klass.define_singleton_method( :new ) do |*args|
      old_new( *args )
    end

    klass
  end

  class << self
    alias_method :old_new, :new       # note: store "old" orginal version of new
    alias_method :new,     :build_class    # replace original version with create
  end
end  # class Event
