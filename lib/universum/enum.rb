# encoding: utf-8

##################################
## auto-create/builds enum class.
##
## Example:
##   State = Enum.new( :fundraising, :expired_refund, :successful)
##     auto-creates/builds:
##
##  class Enum
##    def initialize( key, value )
##      @key   = key
##      @value = value
##    end
##  end
##
##  class State < Enum
##
##    FUNDRAISING    = new(:fundraising,    0)
##    EXPIRED_REFUND = new(:expired_refund, 1)
##    SUCCESSFUL     = new(:successful,     2)
##
##    def self.fundraising()    FUNDRAISING; end
##    def self.expired_refund() EXPIRED_REFUND; end
##    def self.successful()     SUCCESSFUL; end
##
##    def fundraising?()     self == FUNDRAISING; end
##    def expired_refund?()  self == EXPIRED_REFUND; end
##    def successful?()      self == SUCCESSFUL; end
##  end
##
##  pp state = State.fundraising     #=> #<State @key=:fundraising, @value=0>
##  pp state.fundraising?            #=> true
##  pp state.expired_refund?         #=> false
##  pp state.successful?             #=> false
##  pp state = State.expired_refund  #=> #<State @key=:expired_refund, @value=1>
##  pp state.fundraising?            #=> false
##  pp state.expired_refund?         #=> true
##  pp state.successful?             #=> false


## base class for enum
class Enum
  ## return a new Enum read-only class

  def initialize( key, value )
    @key   = key
    @value = value
  end


  ###################
  ##  meta-programming "macro" - build class (on the fly)
  def self.build_class( *keys )

    ## check if all keys are symbols and follow the ruby id(entifier) naming rules
    keys.each do |key|
      if key.is_a?( Symbol ) && key =~ /\A[a-z][a-zA-Z0-9_]*\z/
      else
        raise ArgumentError.new( "[Enum] arguments to Enum.new must be all symbols following the ruby id naming rules; >#{key}< failed" )
      end
    end
       
    klass = Class.new( Enum )

    ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
    klass.define_singleton_method( :new ) do |*args|
      old_new( *args )
    end

    keys.each_with_index do |key,index|
      klass.class_eval( <<RUBY )
        #{key.upcase} = new( :#{key}, #{index} )

        def #{key}?
          self == #{key.upcase}
        end

        def self.#{key}
          #{key.upcase}
        end
RUBY
    end

    klass
  end

  class << self
    alias_method :old_new, :new       # note: store "old" orginal version of new
    alias_method :new,     :build_class    # replace original version with create
  end
end  # class Enum
