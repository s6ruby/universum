# encoding: utf-8


#############
# FIX/FIX/FIX!!!!  - turn Address into a class!!!!


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
end  # module Address



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
