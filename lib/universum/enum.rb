# encoding: utf-8

##################################
## auto-create/builds enum class.
##  Example:
##
##  class Enum; end
##  class State < Enum
##
##    def self.create
##      @fundraising    = new(:fundraising,    0)
##      @expired_refund = new(:expired_refund, 1)
##      @successful     = new(:successful,     2)
##    end
##
##    def self.fundraising()    @fundraising; end
##    def self.expired_refund() @expired_refund; end
##    def self.successful()     @successful; end
##
##    def initialize( name, value )
##      @name  = name
##      @value = value
##    end
##
##    def fundraising?()     self == self.class.fundraising; end
##    def expired_refund?()  self == self.class.expired_refund; end
##    def successful?()      self == self.class.successful; end
##
##    create ## note: call create
##  end
##
##
##  pp state = State.fundraising     #=> #<State @name=:fundraising, @value=0>
##  pp state.fundraising?            #=> true
##  pp state.expired_refund?         #=> false
##  pp state.successful?             #=> false
##  pp state = State.expired_refund  #=> #<State @name=:expired_refund, @value=1>
##  pp state.fundraising?            #=> false
##  pp state.expired_refund?         #=> true
##  pp state.successful?             #=> false


## base class for enum
class Enum
  ## return a new Enum read-only class
  def self.build_class( *names )
    klass = Class.new( Enum )

    ## add self.new too - note: call/forward to "old" orginal self.new of Event (base) class
    klass.define_singleton_method( :new ) do |*args|
      old_new( *args )
    end

    ##################
    ##    def initialize( name, value )
    ##      @name  = name
    ##      @value = value
    ##    end

    klass.class_eval do
      def initialize( name, value )
        @name =  name
        @value = value
      end
    end

    ############################################
    ##    def fundraising?()     self == self.class.fundraising; end
    ##    def expired_refund?()  self == self.class.expired_refund; end
    ##    def successful?()      self == self.class.successful; end

    names.each do |name|
      klass.class_eval( "def #{name}?() self == self.class.#{name}; end" )
    end

    ###################################################
    ##    def self.create
    ##      @fundraising    = new(:fundraising,    0)
    ##      @expired_refund = new(:expired_refund, 1)
    ##      @successful     = new(:successful,     2)
    ##    end

    code = "def create\n"
    names.each_with_index do |name,index|
      code << "   @#{name} = new(:#{name}, #{index})\n"
    end
    code << "end"
    klass.instance_eval( code )

    ####################################################
    ##   def self.fundraising()    @fundraising; end
    ##   def self.expired_refund() @expired_refund; end
    ##   def self.successful()     @successful; end
    names.each do |name|
      code = "def #{name}() @#{name}; end"
      klass.instance_eval( code )
    end

    ###############
    ##  create ## note: call create
    klass.create
    klass
  end

  class << self
    alias_method :old_new, :new       # note: store "old" orginal version of new
    alias_method :new,     :build_class    # replace original version with create
  end
end  # class Enum

