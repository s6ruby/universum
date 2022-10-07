# encoding: utf-8


class Address
  def self.zero() '0x0000'; end

  def initialize( address, balance: 0 )
    @address = address
    @balance = balance
  end

  def hex()     @address; end   ## return address as a hex string (e.g. '0x1111' etc.)
  def balance() @balance; end



  def transfer( value )  ## @payable @public
    ## todo/fix: throw exception if insufficient funds
    ## todo/fix: use assert( send( value )
    send( value )   # returns true/false
  end

  def send( value )  ## @payable @public
    ## note: auto-adds "global" from address (using Universum.this)
    _send( Universum.this, value )
  end


  #############################
  ### private (internal use only) methods - PLEASE do NOT use (use transfer/send)
  def _send( from, value )
    ## todo/fix: assert value > 0
    ## todo/fix: add missing  -= part in transfer!!!!

    ## use this (current contract) for debit (-) ammount
    from._sub( value )    # sub(tract) / debit from the sender (current contract)
    _add( value )         # add / credit to the recipient
  end

  def _sub( value )
    @balance -= value
  end

  def _add( value )
    @balance += value
  end
end  # module Address




class String
  def transfer( value )
    ## check if self is an address
    if self.start_with?( '0x' )
      ## fix/fix/fix:  use Address[self] lookup!!!!
      ##   do NOT use Account any longer
      Account[self].address.transfer( value )
    else
      raise "(Auto-)Type Conversion from Address (Hex) String to Account Failed; Expected String Starting with 0x got #{self}; Contract Halted (Stopped)"
    end
  end

  def send( value )
    ## check if self is an address
    if self.start_with?( '0x' )
      ## fix/fix/fix:  use Address[self] lookup!!!!
      ##   do NOT use Account any longer
      Account[self].address.send( value )
    else
      raise "(Auto-)Type Conversion from Address (Hex) String to Account Failed; Expected String Starting with 0x got #{self}; Contract Halted (Stopped)"
    end
  end
end
