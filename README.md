New to Universum? See the [Universum (World Computer) White Paper](https://github.com/openblockchains/universum/blob/master/WHITEPAPER.md)!



# Universum (Ruby Edition)

next generation ethereum 2.0 world computer runtime - run contract scripts / transactions in plain vanilla / standard ruby on the blockchain - update the (contract-protected / isolated) world states with plain vanilla / standard SQL


* home  :: [github.com/openblockchains/universum](https://github.com/openblockchains/universum)
* bugs  :: [github.com/openblockchains/universum/issues](https://github.com/openblockchains/universum/issues)
* gem   :: [rubygems.org/gems/universum](https://rubygems.org/gems/universum)
* rdoc  :: [rubydoc.info/gems/universum](http://rubydoc.info/gems/universum)


## Usage


### The Greeter - Your Digital Pal Who's Fun to Be With

Let's use the ["Create a digital greeter"](https://www.ethereum.org/greeter) starter example from Ethereum
to compare contracts in Solidity with contracts in Ruby:



``` solidity
pragma solidity >=0.4.22 <0.6.0;

contract Mortal {
    /* Define variable owner of the type address */
    address owner;

    /* This constructor is executed at initialization and sets the owner of the contract */
    constructor() public { owner = msg.sender; }

    /* Function to recover the funds on the contract */
    function kill() public { if (msg.sender == owner) selfdestruct(msg.sender); }
}

contract Greeter is Mortal {
    /* Define variable greeting of the type string */
    string greeting;

    /* This runs when the contract is executed */
    constructor(string memory _greeting) public {
        greeting = _greeting;
    }

    /* Main function */
    function greet() public view returns (string memory) {
        return greeting;
    }
}
```

and

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
end  # class Greeter
```

(Source: [`contracts/greeter.rb`](test/contracts/greeter.rb))



And let's run the greeter with Universum (Uni):

``` ruby
require 'universum'

require_relative 'greeter'


Account['0x1111']    ## setup a test account

tx = Uni.send_transaction( from: '0x1111', data: [Greeter, 'Hello World!'] )
greeter = tx.receipt.contract

puts greeter.greet
#=> Hello World!

tx = Uni.send_transaction( from: '0x1111', data: [Greeter, '¡Hola, mundo!'] )
greeter_es = Receipt[ tx ].contract

puts greeter_es.greet
#=> ¡Hola, mundo!

puts greeter.greet
#=> Hello World!
puts greeter_es.greet
#=> ¡Hola, mundo!
...
```



### The Coin - Minimum Viable Token

What's next? Let's use the ["Create your own crypto-currency"](https://www.ethereum.org/token) example from Ethereum
to compare contracts in Solidity with contracts in Ruby again:

``` solidity
pragma solidity >=0.4.22 <0.6.0;

contract MyToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(
        uint256 initialSupply
        ) public {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        return true;
    }
}
```

and

``` ruby
class MyToken < Contract

  def initialize( initial_supply )
    @balance_of = Mapping.of( Address => Money )
    @balance_of[ msg.sender] = initial_supply
  end

  def transfer( to, value )
    assert( @balance_of[ msg.sender ] >= value )
    assert( @balance_of[ to ] + value >= @balance_of[ to ] )

    @balance_of[ msg.sender ] -= value
    @balance_of[ to ]         += value

    return true
  end
end   # class MyToken
```

(Source: [`contracts/mytoken.rb`](test/contracts/mytoken.rb))




## More Contract Samples

See the [`/universum-contracts`](https://github.com/openblockchains/universum-contracts) collection.


## More Documentation / Articles / Contracts

[Programming Crypto Blockchain Contracts Step-by-Step Book / Guide](https://github.com/openblockchains/programming-cryptocontracts) - Let's Start with Ponzi & Pyramid Schemes. Run Your Own Lotteries, Gambling Casinos and more on the Blockchain World Computer...



## Install

Just install the gem:

```
$ gem install universum
```


## License

The `universum` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.


## Questions? Comments?

Send them along to the [wwwmake forum](http://groups.google.com/group/wwwmake).
Thanks!
