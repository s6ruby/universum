# encoding: utf-8


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
        @contract_address = "#{contract.address.hex} (#{contract.class.name})"
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
