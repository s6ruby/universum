

BetPlaced = Event.new( :id, :user, :cap, :amount )

Roll      = Event.new( :id, :rolled )

b = BetPlaced.new( 1, '0xaaaa', 2000, 100 )
assert       b.is_a? Event
assert_equal 1         == b.id
'0xaaaa'  == b.user
2000      == b.cap
100       == b.amount

r = Roll.new( 1, 2345 )
assert      r.is_a? Event
assert_equal 1    == r.id
assert_equal 2345 == r.rolled

