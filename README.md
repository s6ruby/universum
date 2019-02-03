New to Universum? See the [Universum (World Computer) White Paper](https://github.com/openblockchains/universum/blob/master/WHITEPAPER.md)!



# Universum (Ruby Edition)

next generation ethereum 2.0 world computer runtime - run contract scripts / transactions in plain vanilla / standard ruby on the blockchain - update the (contract-protected / isolated) world states with plain vanilla / standard SQL



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
