# encoding: utf-8


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
