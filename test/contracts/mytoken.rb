# encoding: utf-8


class MyToken < Contract

  def initialize( initial_supply )
    @balance_of = Mapping.of( Address => Money )
    @balance_of[ msg.sender] = initial_supply
  end

  def transfer( to, value )
    assert( @balance_of[ msg.sender ] >= value )
    assert( @balance_of[ to ] + value >= @balance_of[ to ] )

    @balance_of[ msg.sender ] -= value
    @balance_of[ to ]         += value

    true
  end
end   # class MyToken
