# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_enum.rb


require 'helper'


class TestEnum < MiniTest::Test

  State = Enum.new( :fundraising, :expired_refund, :successful )

def test_state
  pp State

  state = State.fundraising
  assert state.is_a?( Enum )

  assert_equal true,  state.fundraising?
  assert_equal false, state.expired_refund?
  assert_equal false, state.successful?

  state = State.expired_refund
  assert_equal false, state.fundraising?
  assert_equal true,  state.expired_refund?
  assert_equal false, state.successful?
end
end # class TestEnum
