# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_struct.rb


require 'helper'


class TestStruct < MiniTest::Test

  ## sig: [Integer, Bool, Integer, Address]
  Voter = Struct.new( :weight, :voted, :vote, :delegate ) do
     def self.new_zero
       new( 0, false, 0, '0x0000' )
     end
     def self.zero
       @zero ||= new_zero
     end
  end


def test_zero
  assert_equal Voter.zero, Voter.zero

  zerodup = Voter.zero.dup
  zerodup.delegate = '0x1111'
  pp zerodup

  assert_equal '0x0000', Voter.zero.delegate
end


##########
##  todo/fix!!!
    
Bet = Struct.new( user:   Address(0),
                      block:  0,
                      cap:    0,
                      amount: 0 )

pp Bet
bet = Bet.new_zero
pp bet
bet.cap    = 20_000
bet.amount = 100
pp bet
pp Bet.zero
pp Bet.zero
pp bet.is_a? Struct

bet = Bet.new_zero
pp bet
pp Bet.zero
pp Bet.zero
pp Bet.new( 0, 0, 0, 0 )
pp bet.is_a? Struct

pp Bet.new
pp Bet.new_zero
pp Bet.zero
pp Bet.zero
  

end # class TestStruct
