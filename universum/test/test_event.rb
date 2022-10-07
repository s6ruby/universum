# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_event.rb


require 'helper'


class TestEvent < MiniTest::Test
  include Safe

  ## Event.new( :BetPlaced, :id, :user, :cap, :amount )
  ## Event.new( :Roll, :id, :rolled )
  event :BetPlaced, :id, :user, :cap, :amount
  event :Roll, :id, :rolled


def test_bet_placed
  pp BetPlaced

  bet = BetPlaced.new( 1, '0xaaaa', 2000, 100 )

  assert       bet.is_a?( Event )
  assert_equal 1,        bet.id
  assert_equal '0xaaaa', bet.user
  assert_equal 2000,     bet.cap
  assert_equal 100,      bet.amount
  assert_equal true,     bet.frozen?
end

def test_roll
  pp Roll

  roll = Roll.new( 1, 2345 )
  assert       roll.is_a?( Event )
  assert_equal 1,    roll.id
  assert_equal 2345, roll.rolled
  assert_equal true, roll.frozen?
end

end # class TestEvent
