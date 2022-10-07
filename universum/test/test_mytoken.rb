# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_mytoken.rb


require 'helper'



class TestMyToken < MiniTest::Test

MyToken = Contract.load( "#{Universum.root}/test/contracts/mytoken" )

def test_uni
   Account['0x1111']
   Account['0xaaaa']
   Account['0xbbbb']

   tx = Uni.send_transaction( from: '0x1111', data: [MyToken, 100_000_000] )
   pp tx
   pp tx.receipt

   token = tx.receipt.contract

   Uni.send_transaction( from: '0x1111', to: token, data: [:transfer, '0xaaaa', 100] )
   Uni.send_transaction( from: '0x1111', to: token, data: [:transfer, '0xbbbb', 200] )
   Uni.send_transaction( from: '0xbbbb', to: token, data: [:transfer, '0xaaaa', 10] )
   pp token
end

end # class TestMyToken
