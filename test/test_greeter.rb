# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_greeter.rb


require 'helper'


require 'contracts/greeter'    ## use require_relative - why? why not?


class TestGreeter < MiniTest::Test

def test_run
   account = Account['0x1111']

   tx = Uni.send_transaction( from: '0x1111', data: [Greeter, 'Hello World!'] )
   pp tx
   pp tx.receipt

   greeter = tx.receipt.contract

   assert 'Hello World!', greeter.greet
   assert 'Hello World!', greeter.greet

   tx = Uni.send_transaction( from: '0x1111', data: [Greeter, '¡Hola, mundo!'] )

   greeter_es = Receipt[ tx ].contract

   assert '¡Hola, mundo!', greeter_es.greet

   assert 'Hello World!',   greeter.greet
   assert '¡Hola, mundo!',  greeter_es.greet
end

end # class TestGreeter
