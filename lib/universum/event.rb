# encoding: utf-8

##################################
## auto-create/builds struct-like class.
##
## Example:
##  Event.new( :Roll, :id, :rolled )
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


module Safe
## base class for events
class Event
  ## return a new Struct-like read-only class

  ###################
  ##  meta-programming "macro" - build class (on the fly)
  ##
  def self.build_class( class_name, *fields )
    klass = Class.new( Event ) do
      define_method( :initialize ) do |*args|
        fields.zip( args ).each do |field, arg|
          instance_variable_set( "@#{field}", arg )
        end
        freeze    ### note: add freeze - assumes "immutable" struct-like class
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

    ## note: use Safe (module) and NOT Object for namespacing
    ##   use include Safe to make all structs global
    Safe.const_set( class_name, klass )   ## returns klass (plus sets global constant class name)

    klass
  end

  class << self
    alias_method :old_new, :new       # note: store "old" orginal version of new
    alias_method :new,     :build_class    # replace original version with create
  end
end  # class Event

module SafeHelper
  def event( class_name, *args )
    ########################################
    # note: lets you use:
    #   enum :Color, :red, :green, :blue
    #    -or-
    #   enum :Color, [:red, :green, :blue]
    if args[0].is_a?( Array )
      fields = args[0]
    else
      fields = args
    end

    Event.new( class_name, *fields )
  end
end # module SafeHelper
end # module Safe
