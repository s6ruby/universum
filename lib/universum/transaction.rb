# encoding: utf-8


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

    @from = account.address.hex

    if to.is_a?( Contract )
      @to = "#{to.address.hex} (#{to.class.name})"
    elsif to.is_a?( Account )     ## note: to allows Contracts AND Accounts
      @to = to.address.hex
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
