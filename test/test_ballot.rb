# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_ballot.rb


require 'helper'



class TestBallot < MiniTest::Test

Ballot = Contract.load( "#{Universum.root}/test/contracts/ballot" )

def test_uni
   Account['0x1111']    ### todo/fix: auto-add account in from: if not present or missing!!!!
   Account['0xaaaa']
   Account['0xbbbb']
   Account['0xcccc']
   Account['0xdddd']

   tx = Uni.send_transaction( from: '0x1111', data: [Ballot, 2] )
   pp tx
   pp tx.receipt

   ballot = tx.receipt.contract
   pp ballot

   Uni.send_transaction( from: '0x1111', to: ballot, data: [:give_right_to_vote, '0xaaaa'] )
   Uni.send_transaction( from: '0x1111', to: ballot, data: [:give_right_to_vote, '0xbbbb'] )
   Uni.send_transaction( from: '0x1111', to: ballot, data: [:give_right_to_vote, '0xcccc'] )
   Uni.send_transaction( from: '0x1111', to: ballot, data: [:give_right_to_vote, '0xdddd'] )
   pp ballot

   Uni.send_transaction( from: '0xaaaa', to: ballot, data: [:vote, 1] )
   Uni.send_transaction( from: '0xbbbb', to: ballot, data: [:delegate, '0xaaaa'] )
   Uni.send_transaction( from: '0xcccc', to: ballot, data: [:vote, 0] )
   Uni.send_transaction( from: '0xdddd', to: ballot, data: [:delegate, '0xbbbb'] )
   pp ballot

   ## todo/fix: get return value from sent_transaction
   assert_equal 1, ballot.winning_proposal
end

end # class TestBallot
