# encoding: utf-8


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
