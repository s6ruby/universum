# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_hash.rb


require 'helper'


class TestHash < MiniTest::Test

  Hash_X_Integer = SafeHash.build_class( String, Integer )
  Hash_X_Bool    = SafeHash.build_class( String, Bool )

def test_integer
  pp Hash_X_Integer
  pp h = Hash_X_Integer.new

  assert_equal Integer, Hash_X_Integer.klass_value
  assert_equal 0,  h['0x1111']
  assert_equal 0,  h['0x2222']

  h['0x1111'] = 101
  h['0x2222'] = 102
  assert_equal 101,  h['0x1111']
  assert_equal 102,  h['0x2222']

  ## check Mapping.of  (uses cached classes)
  assert_equal Hash_X_Integer, Mapping.of( String => Integer ).class
end


def test_bool
  pp Hash_X_Bool
  pp h = Hash_X_Bool.new

  assert_equal Bool, Hash_X_Bool.klass_value
  assert_equal false,  h['0x1111']
  assert_equal false,  h['0x2222']

  h['0x1111'] = true
  h['0x2222'] = true
  assert_equal true,  h['0x1111']
  assert_equal true,  h['0x2222']

  ## check Mapping.of  (uses cached classes)
  assert_equal Hash_X_Bool, Mapping.of( String => Bool ).class
end


def test_zero_dup
  assert_equal Hash_X_Integer.zero, Hash_X_Integer.zero

  zerodup = Hash_X_Integer.zero.dup
  zerodup['0x111'] += 1
  pp zerodup

  assert_equal 0, Hash_X_Integer.zero.size   ## hash empty?
end


end # class TestHash
