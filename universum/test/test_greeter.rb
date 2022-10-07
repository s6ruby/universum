# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_greeter.rb


require 'helper'



class TestGreeter < MiniTest::Test

Greeter = Contract.load( "#{Universum.root}/test/contracts/greeter" )

def test_uni
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

def test_tx
   account = Account['0x1111']

   tx = Tx.send( from: '0x1111', data: [Greeter, 'Hello World!'] )
   pp tx
   pp tx.receipt

   greeter = tx.receipt.contract

   assert 'Hello World!', greeter.greet
   assert 'Hello World!', greeter.greet

   tx = Tx.send( from: '0x1111', data: [Greeter, '¡Hola, mundo!'] )

   greeter_es = Receipt[ tx ].contract

   assert '¡Hola, mundo!', greeter_es.greet

   assert 'Hello World!',   greeter.greet
   assert '¡Hola, mundo!',  greeter_es.greet
end


end # class TestGreeter
