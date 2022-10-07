# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_storage.rb


require 'helper'




class TestStorage < MiniTest::Test

def test_storage

  s = Storage.new
  s[:balance]
  s[:balance] = {}
  s[:balance]['0xaaaa'] = 100
  s[:balance]['0xbbbb'] = 200
  pp s

  balance_exp = { '0xaaaa'=>100, '0xbbbb'=>200 }
  assert_equal balance_exp, s.balance
  assert_equal 100, s.balance['0xaaaa']
  assert_equal 200, s.balance['0xbbbb']

  s.balance['0xcccc'] = 300
  assert_equal 300, s.balance['0xcccc']

  s.owner     = '0x1111'
  assert_equal '0x1111', s.owner
end

end # class TestStorage
