# Universum (World Computer) White Paper

Revolution / Evolution - Adapt or Die - What's Next?


## 2008 - Bitcoin

Proof-of-Pudding. Yes, it worked in the beginning.
Ten years later it's a HODLer greed-fest 
waiting to collapse. Why? 
The point and value is using bitcoin for (decentralized person-to-person) 
payments, payments, payments and not for HODLing. 

Remember the promises of banking the unbanked or free (or less than 1% low-fee) person-to-person payment transactions 
and on and on. FAIL. FAIL. FAIL.

Where's the consenus to make bitcoin better? 
Insane / lunatic proof-of-work mining difficulty. Centralized mining pools.
 And on and on. New currencies will take over. 
Thanks to bitcoin for showing what's possible. 
The bitcoin show is over. Old gold bugs HODLing old "fossilized" tech waiting for a get-rich / to the moon miracle. 



## 2015 - Ethereum

What's News? What's Great about Ethereum (vs "Ye Olde" Bitcoin)?

- "Turing-Complete" (Blockchain) Contract Programming Language
  - e.g. Solidity (JavaScript-Like), Vyper (Python-Like), LLL (Lisp-Like), etc.
- Contracts Own Accounts (& Budgets)
- Isolated / Protected (Blockchain) Storage for Contracts
- And more

Developer. Developer. Developer.

Remember the Nokia or Blackberry mobile phones? What happened? 
Yes, Contracts. Contracts. Contracts are the new Apps. Apps. Apps.



## 2018 - Universum 

What's Wrong with Ethereum?

Not-Invented-Here, Not-Invented-Here, Not-Invented-Here Syndrome:

- Proprietary Contract Programming Language
- Proprietary Virtual Machine (& Bytecode Instructions)
- Proprietary "World State" Transition
- Proprietary "World" Database / Storage


Why not use the world's best and most popular programming languages for your contract / transaction scripts?

Universum will start with 25-year-old standard plain vanilla ruby as an example on how to use a popular general-purpose programming language for "turing-complete" (blockchain) contract programming.   

And the "virtual machine" is the standard language runtime itself.

What about security?

The "world state" transitions get serialized into standard plain-vanilla SQL statements.


Why SQL?

SQL is the 40-year-old industry standard for database "state transitions".

And for (extra) security (and scalability) 
every contract gets its own isolated / protected SQL database (storage).


To summarize:

- **NO** Proprietary Contract Programming Language => Use Any Standard Language
- **NO** Proprietary Virtual Machine  => Use Any Standard Runtime or Binary Program
- **NO** Proprietary "World State" Transition  => Use SQL Statements (INSERT / UPDATE / DELETE)
- **NO** Proprietary "World" (Blockchain) Database / Storage => Use SQL Databases


Join in. Version 0.1 (code-named Big Bang) upcoming.



---

## Apendix

Token Contract Sample Script - [`tokens/token_test.rb`](https://github.com/openblockchains/universe/blob/master/tokens/token_test.rb):

``` ruby
# To test the contract script run:
#   $ ruby tokens/token_test.rb


require 'minitest/autorun'

require_relative 'token'

class TestToken < Minitest::Test

  def setup
    @token = Token.new(
      name:          'Your Crypto Token',
      symbol:        'YOU',
      decimals:       8,
      initial_supply: 1_000_000
    )
  end

  def test_transfer
    assert_equal 100_000_000_000_000, @token.balance_of( owner: '0x0000' )
    assert_equal 0,                   @token.balance_of( owner: '0x1111' )

    assert @token.transfer( to: '0x1111', value: 100 )
    assert_equal 100, @token.balance_of( owner: '0x1111' )

    assert @token.transfer( to: '0x2222', value: 200 )
    assert_equal 200, @token.balance_of( owner: '0x2222' )

    assert_equal 99_999_999_999_700, @token.balance_of( owner: '0x0000' )
  end


  def test_transfer_from 
    assert !@token.transfer_from( from: '0x1111', to: '03333', value: 30 ) ## note: NOT pre-approved - will FAIL
    assert_equal 0, @token.allowance( owner: '0x0000', spender: '0x1111' )

    assert @token.approve( spender: '0x1111', value: 50 )
    assert_equal 50, @token.allowance( owner: '0x0000', spender: '0x1111' )

    
    Contract.msg = { sender: '0x1111' }  ## change sender to 0x1111
    
    assert @token.transfer_from( from: '0x0000', to: '0x3333', value: 30 )
    assert_equal 30,                 @token.balance_of( owner: '0x3333' )
    assert_equal 99_999_999_999_970, @token.balance_of( owner: '0x0000' )
    assert_equal 0,                  @token.balance_of( owner: '0x1111' )

    
    Contract.msg = { sender: '0x0000' }  ## change sender back to 0x0000
    pp Contract.msg

    assert @token.transfer( to: '0x1111', value: 1 )
    assert_equal 99_999_999_999_969, @token.balance_of( owner: '0x0000' )
    assert_equal 1,                  @token.balance_of( owner: '0x1111' )
  end

end # class TestToken
```
