_Ruby for Contract / Transaction Scripts on the Blockchain (World Computer)_

# sruby - Simple, Secure, Safe, Solid & Sound Ruby

sruby is a subset of mruby that is a subset of "classic" ruby.


## What's missing and why?


Less is more. The golden rule of secure code is keep it simple, stupid.

- NO inheritance
- NO recursion
- NO re-entrance - auto-magic protection on function calls
- NO floating point numbers or arithmetic
- NO overflow & underflow in numbers - auto-magic "safe-math" protection
- and much much more



## What's the upside?

You can cross-compile (transpile) contract scripts (*) to:

- Solidity - JavaScript-like contract scripts
- Vyper - Python-like contract scripts
- EVM (Ethereum Virtual Machine) Assembly
- and much much more


(*) in the future.


## Yes, yes, yes - It's still "plain-vanilla" ruby

Remember - the code is still and always will be "plain-vanilla" ruby
that runs with "classic" ruby or mruby "out-of-the-box".


## Contract Samples


**Hello, World! - Greeter**

``` ruby
class Greeter < Contract

  def initialize( greeting )
    @owner    = msg.sender
    @greeting = greeting
  end

  def greet
    @greeting
  end

  def kill
    selfdestruct( msg.sender )  if msg.sender == @owner
  end
end
```


**Mint Your Own Money - Minimal Viable Token**

``` ruby
class Token < Contract

  def initialize( initial_supply )
    @balance_of = Mapping.of( Address => Money )
    @balance_of[ msg.sender] = initial_supply
  end

  def transfer( to, value )
    assert( @balance_of[ msg.sender ] >= value )
    assert( @balance_of[ to ] + value >= @balance_of[ to ] )

    @balance_of[ msg.sender ] -= value
    @balance_of[ to ]         += value

    true
  end
end
```


**Win x65 000 - Roll the (Satoshi) Dice**

``` ruby
class SatoshiDice < Contract

  Bet = Struct.new( :user, :block, :cap, :amount )

  ## Fee (Casino House Edge) is 1.9%, that is, 19 / 1000
  FEE_NUMERATOR   = 19
  FEE_DENOMINATOR = 1000

  MAXIMUM_CAP = 2**16   # 65_536 = 2^16 = 2 byte/16 bit
  MAXIMUM_BET = 100_000_000
  MINIMUM_BET = 100

  BetPlaced = Event.new( :id, :user, :cap, :amount )
  Roll      = Event.new( :id, :rolled )


  def initialize
    @owner   = msg.sender
    @counter = 0
    @bets    = Mapping.of( Integer => Bet )
  end

  def bet( cap )
     assert( cap >= 1 && cap <= MAXIMUM_CAP )
     assert( msg.value >= MINIMUM_BET && msg.value <= MAXIMUM_BET )

     @counter += 1
     @bets[@counter] = Bet.new( msg.sender, block.number+3, cap, msg.value )
     log BetPlaced.new( @counter, msg.sender, cap, msg.value )
  end

  def roll( id )
    bet = @bets[id]

    assert( msg.sender == bet.user )
    assert( block.number >= bet.block )
    assert( block.number <= bet.block + 255 )

    ## "provable" fair - random number depends on
    ##  - blockhash (of block in the future - t+3)
    ##  - nonce (that is, bet counter id)
    hex = sha256( "#{blockhash( bet.block )} #{id}" )
    ## get first 2 bytes (4 chars in hex string) and convert to integer number
    ##   results in a number between 0 and 65_535
    rolled = hex_to_i( hex[0,4] )

    if rolled < bet.cap
       payout = bet.amount * MAXIMUM_CAP / bet.cap
       fee = payout * FEE_NUMERATOR / FEE_DENOMINATOR
       payout -= fee

       msg.sender.transfer( payout )
    end

    log Roll.new( id, rolled )
    @bets.delete( id )
  end

  def fund
  end

  def kill
    assert( msg.sender == @owner )
    selfdestruct( @owner )
  end
end
```




## Request for Comments (RFC)

Send your questions and comments to the ruby-talk mailing list. Thanks!
