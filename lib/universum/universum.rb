# encoding: utf-8



def sha256( str )
  Digest::SHA256.hexdigest( str )
end



module Address
  def self.zero() '0x0000'; end

  def address
    if @address
      @address
    else
      if is_a? Contract
         ##  fix/todo:  use/lookup proper addr from contract
         ## construct address for now from object_id
         "0x#{(object_id << 1).to_s(16)}"
      else  ## assume Account
         '0x0000'
      end
    end
  end # method address

  def transfer( value )  ## @payable @public
    ## todo/fix: throw exception if insufficient funds
    send( value )   # returns true/false
  end

  def send( value )  ## @payable @public
    ## todo/fix: assert value > 0
    ## todo/fix: add missing  -= part in transfer!!!!

    ## use this (current contract) for debit (-) ammount
    this._sub( value )    # sub(tract) / debit from the sender (current contract)
    _add( value )         # add / credit to the recipient
  end

  def balance
    @balance ||= 0   ## return 0 if undefined
  end

  ### private (internal use only) methods - PLEASE do NOT use (use transfer/send)
  def _sub( value )
    @balance ||= 0   ## return 0 if undefined
    @balance -= value
  end

  def _add( value )
    @balance ||= 0   ## return 0 if undefined
    @balance += value
  end
end  # class Address


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
       if arg[0][1] == Integer
         Hash.new( Integer.zero )     ## if key missing returns 0 and NOT nil (the default)
       elsif arg[0][1] == Money
         Hash.new( Money.zero )     ## if key missing returns 0 and NOT nil (the default)
       elsif arg[0][1] == Bool
         Hash.new( Bool.zero )
       elsif arg[0][1] == Address
         Hash.new( Address.zero )
       else   ## assume "standard" defaults
         ## todo: issue warning about unknown type - why? why not?
         Hash.new
       end
     else
       Hash.new    ## that is, "plain" {} with all "standard" defaults
     end
  end
end




class Array
  def self.of( *args )
     Array.new    ## that is, "plain" [] with all "standard" defaults
  end
end


class String
  def transfer( value )
    ## check if self is an address
    if self.start_with?( '0x' )
      Account[self].transfer( value )
    else
      raise "(Auto-)Type Conversion from Address (Hex) String to Account Failed; Expected String Starting with 0x got #{self}; Contract Halted (Stopped)"
    end
  end

  def send( value )
    ## check if self is an address
    if self.start_with?( '0x' )
      Account[self].send( value )
    else
      raise "(Auto-)Type Conversion from Address (Hex) String to Account Failed; Expected String Starting with 0x got #{self}; Contract Halted (Stopped)"
    end
  end
end


class Account

  @@directory = {}
  def self.find_by_address( key )
     ## clean key (allow "embedded" name e.g 0x1111 (Alice))
     key = key.gsub(/\(.+\)/, '' ).strip
     @@directory[ key ]
  end
  def self.find( key ) find_by_address( key ); end   # make find_by_address the default finder
  def self.at( key) find_by_address( key ); end   # another "classic" alias for find_by_address

  def self.[]( key )
    o = find_by_address( key )
    if o
      o
    else
      o = new( key )
      ## note: auto-register (new) address in (yellow page) directory
      @@directory[ key ] = o
      o
    end
  end

  def self.all()  @@directory.values;  end


  ####
  #  account (builtin) services / transaction methods
  include Address    ## includes address + send/transfer/balance

  ## note: for now allow write access too!!!
  def balance=( value )
    @balance = value
  end

  attr_reader :tx
  def _auto_inc_tx() @tx += 1; end   ## "internal" method - (auto) increment transaction (tx) counter

  ## note: needed by transfer/send
  def this()       Universum.this;         end   ## returns current contract

private
  def initialize( address, balance: 0, tx: 0 )
    @address = address    # type address - (hex) string starts with 0x
    @balance = balance    # uint
    @tx      = tx         # transaction (tx) count (used for nonce and replay attack protection)
  end

end # class Account


class Contract
 
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




## blockchain message (msg) context
##   includes:  sender (address)
##  todo: allow writable attribues e.g. sender - why? why not?
class Msg
  attr_reader :sender, :value

  def initialize( sender: '0x0000', value: 0 )
    @sender = sender
    @value  = value
  end
end  # class Msg



class Block
  attr_reader :timestamp, :number

  def initialize( timestamp: Time.now.to_i, number: 0 )
    @timestamp = timestamp   # unix epoch time (in seconds since 1970)
    @number    = number      # block height (start with 0 - genesis block)
  end
end  # class Block



class Transaction

  def self.send( **kwargs )  ## convenience helper for Uni.send_transaction
    Universum.send_transaction( **kwargs )
  end


  attr_reader :from, :to, :value, :data, :nonce

  def initialize( from:, to:, value:, data:, nonce: nil )
    ## note: from only allows accounts
    if from.is_a?( Account )
      account = from
    else
      account = Account.at( from )   ## lookup account by address
    end

    @from = account.address

    if to.is_a?( Contract )
      @to = "#{to.address} (#{to.class.name})"
    elsif to.is_a?( Account )     ## note: to allows Contracts AND Accounts
      @to = to.address
    else
      @to = to    # might be a contract or account (pass through for now)
    end

    @value = value
    @data  = data

    if nonce
      @nonce = nonce
    else
      ## auto-add nonce (that is, tx counter - auto-increment)
      @nonce = account.tx  ## get transaction (tx) counter (starts with 0)
      account._auto_inc_tx
    end
  end

  def log_str
    ## for debug add transaction (tx) args (e.g. from, value, etc.)
    tx_args_str = ""
    tx_args_str << "from: #{@from} ##{@nonce}"
    tx_args_str << ", value: #{@value}"  if @value > 0

    if @to == '0x0000'  ## special case - contract creation transaction
      klass      = @data[0]       ## contract class - todo/fix: check if data[] is a contract class!!!
      call_args  = @data[1..-1]   ## arguments

      ## convert all args to string (with inspect) for debugging
      ##   check if pretty_inspect adds trailing newline? why? why not? possible?
      call_args_str = call_args.reduce( [] ) { |ary,arg| ary; ary << arg.inspect }.join( ', ' )

      "#{tx_args_str} => to: #{@to} create contract #{klass.name}.new( #{call_args_str} )"
    else
      if @data.empty?  ## assume receive (default method) for now if data empty (no method specified)
        "#{tx_args_str} => to: #{@to} call default fallback"
      else
        m         = @data[0]       ## method name / signature
        call_args = @data[1..-1]   ## arguments

        ## convert all args to string (with inspect) for debugging
        ##   check if pretty_inspect adds trailing newline? why? why not? possible?
        call_args_str = call_args.reduce( [] ) { |ary,arg| ary; ary << arg.inspect }.join( ', ' )

        "#{tx_args_str} => to: #{@to} call #{m}( #{call_args_str} )"
      end
    end
  end


  def receipt
    Receipt.find( self )
  end

  def contract   # convenience helper (quick contract lookup)
    rec = receipt
    if rec
      rec.contract
    else
      nil
    end
  end
end  # class Transaction

Tx = Transaction    ## add some convenience aliases (still undecided what's the most popular :-)




class Receipt   ## transaction receipt

  @@directory = {}
  def self.find( tx )
     key = "#{tx.from}/#{tx.nonce}"
     @@directory[ key ];
  end
  def self.[]( tx ) find( tx ); end

  def self.store( o )
     key = "#{o.from}/#{o.nonce}"
     @@directory.store( key, o ); end  ## store (add) new receipt object (o) to hash / directory
  def self.all() @@directory.values; end


   ## required attributes / fields
   attr_reader :nonce, :from, :to, :value,
               :block_number
   ## optional
   attr_reader :contract_address

   def initialize( tx:,
                   block:,
                   contract: nil )
      @nonce = tx.nonce
      @from  = tx.from
      @to    = tx.to
      @value = tx.value
      ## todo/fix: add data too!!!

      @block_number    = block.number
      ## todo/fix: add block_hash

      if contract
        ## note: for easier debugging add class name in () to address (needs to get stripped away in lookup)
        @contract_address = "#{contract.address} (#{contract.class.name})"
      else
        @contract_address = nil
      end
   end

   def contract   # convenience helper (quick contract lookup)
     if @contract_address
       Contract.find( @contract_address )
     else
       nil
     end
   end
end




class Universum   ## Uni short for Universum
  ## convenience helpers

  def self.send_transaction( from:, to: '0x0000', value: 0, data: [] )
    counter = @@counter ||= 0    ## total tx counter for debugging (start with 0)
    @@counter += 1

    ## note: always lookup (use) account for now
    if from.is_a?( Account )
      account = from
    else
      account = Account.at( from )
    end

    ## setup contract msg context
    self.msg = { sender: account.address, value: value }


    ## allow shortcut for Class (without ctor arguments) - no need to wrap in array
    data = [data]   if data.is_a? Class

    tx = Transaction.new( from: account, to: to, value: value, data: data )


    ## special case - contract creation transaction
    if to == '0x0000'
      klass = data[0]       ## contract class - todo/fix: check if data[] is a contract class!!!
      args  = data[1..-1]   ## arguments

      puts "** tx ##{counter} (block ##{block.number}): #{tx.log_str}"
      contract = klass.new( *args )   ## note: balance and this (and msg.send/transfer) NOT available/possible !!!!

      if value > 0
        ## move value to msg (todo/fix: restore if exception)
        account._sub( value )  # (sub)tract / debit from the sender (account)
        contract._add( value )        # add / credit to the recipient
      end

      puts " new #{contract.class.name} contract adddress: #{contract.address.inspect}"
      ## add new contract to (lookup) directory
      Contract.store( contract.address, contract )

      ## issue (mined) transaction receipt
      receipt = Receipt.new( tx: tx,
                             block: block,
                             contract: contract )
    else
       if value > 0
         ## move value to msg (todo/fix: restore if exception)
         account._sub( value )  # (sub)tract / debit from the sender (account)
         to._add( value )       # add / credit to the recipient
       end

       self.this = to    ## assumes for now that to is always a contract (and NOT an account)!!!

       data = [:receive]   if data.empty?  ## assume receive (default method) for now if data empty (no method specified)

       m    = data[0]       ## method name / signature
       args = data[1..-1]   ## arguments

       puts "** tx ##{counter} (block ##{block.number}): #{tx.log_str}"

       to.__send__( m, *args )    ## note: use __send__ to avoid clash with send( value ) for sending payments!!!

       ## issue (mined) transaction receipt
       receipt = Receipt.new( tx: tx,
                              block: block )
    end

    Receipt.store( receipt )
    tx   # return transaction
  end


  def self.accounts()  Account.all; end
  def self.contracts() Contract.all; end


  def self.msg
    @@msg ||= Msg.new
  end

  def self.msg=( value )
    if value.is_a? Hash
      kwargs = value
      @@msg = Msg.new( kwargs )
    else   ## assume Msg class/type
      @@msg = value
    end
  end


  def self.blockhash( number )
    ## for now return "dummy" blockhash
    sha256( "blockhash #{number}" )
  end

  def self.block
    @@block ||= Block.new
  end

  def self.block=( value )
    if value.is_a? Hash
      kwargs = value
      @@block = Block.new( kwargs )
    else   ## assume Block class/type
      @@block = value
    end
  end

  def self.this    ## returns current contract
    @@this
  end

  def self.this=(value)
    ## todo/fix: check that value is a contract
    @@this = value
  end


  def self.handlers    ## use listeners/observers/subscribers/... - why? why not?
    @@handlers ||= []
  end

  def self.log( event )
    handlers.each { |h| h.call( event ) }
  end
end  ## class Universum



Uni = Universum   ## add some convenience aliases (still undecided what's the most popular :-)
UNI = Universum
UN  = Universum
U   = Universum


## (auto-)add (debug) log handler for now - pretty print (pp) events to console
Uni.handlers << (->(event) { puts "** event: #{event.pretty_inspect}" })
