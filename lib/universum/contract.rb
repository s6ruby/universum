# encoding: utf-8


class Contract

  include Safe    # adds support for SafeStruct (Struct), SafeArray (Array), SafeHash (Mapping)
  #########
  # load "class-less" contract
  #   e.g.   SathoshiDice = Contract.load( './sathoshi_dice' )
  def self.load( path )
    extname = File.extname( path )   #=> ".rb"
    if extname == '.rb'
      ## do nothing
    else
      ## "convenience" helper - (auto-)add .rb extension
      path = "#{path}.rb"
    end

    code = File.open( path, 'r:bom|utf-8' ) { |f| f.read }
    klass = Class.new( Contract )
    klass.class_eval( code )   ## note: use class_eval (NOT instance_eval)
    klass
  end


  @@directory = {}
  def self.find_by_address( key )
     ## clean key (allow "embedded" class name e.g 0x4de2ee8 (SatoshiDice))
     key = key.gsub(/\(.+\)/, '' ).strip
     @@directory[ key ];
  end
  def self.find( key ) find_by_address( key ); end   # make find_by_address the default finder
  def self.at( key) find_by_address( key ); end     # another "classic" alias for find_by_address
  def self.[]( key ) find_by_address( key ); end

  def self.store( key, o ) @@directory.store( key, o ); end  ## store (add) new contract object (o) to hash / directory
  def self.all() @@directory.values; end



  ####
  #  account (builtin) services / transaction methods
  include Address    ## includes address + send/transfer/balance

  ## function sig(nature) macro for types (dummy for now)
  # e.g. use like
  #   payable :process
  #   payable :initialize
  #   payable :bet, Integer
  #   payable :lend_money, Address => Bool   ## returns Bool
  def self.payable( *args ); end

  payable :receive

  ####
  #  todo/double check: auto-add payable default fallback - why? why not?
  def receive    ## @payable default fallback - use different name - why? why not? (e.g. handle/process/etc.)
  end


  def assert( condition )
    if condition == true
      ## do nothing
    else
      raise 'Contract Assertion Failed; Contract Halted (Stopped)'
    end
  end


  def this()       Universum.this;         end   ## returns current contract
  def log( event ) Universum.log( event ); end
  def msg()        Universum.msg;          end
  def block()      Universum.block;        end
  def blockhash( number )
    ## todo/fix: only allow going back 255 blocks; check if number is in range!!!
    Universum.blockhash( number )
  end

private
  def selfdestruct( owner )   ## todo/check: use a different name e.g. destruct/ delete - why? why not?
    ## selfdestruct function (for clean-up on blockchain)
    owner.send( @balance )    ## send back all funds owned/hold by contract

     ## fix: does nothing for now - add some code (e.g. cleanup)
     ##  mark as destruct - why? why not?
  end

end  # class Contract
