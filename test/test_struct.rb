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
     def self.by_ref?()   true;   end   ## reference semantics?
     def self.by_value?() false;  end   ## value semantics?
  end


def test_zero
  assert_equal Voter.zero, Voter.zero

  zerodup = Voter.zero.dup
  zerodup.delegate = '0x1111'
  pp zerodup

  assert_equal '0x0000', Voter.zero.delegate
end


end # class TestStruct
