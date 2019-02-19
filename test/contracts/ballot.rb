#########################
# Ballot Contract

Voter    = Struct.new( weight:   0,
                       voted:    false,
                       vote:     0,
                       delegate: Address(0))

Proposal = Struct.new( vote_count: 0 )

## Create a new ballot with $(num_proposals) different proposals.
def setup( num_proposals )
  @chairperson = msg.sender
  @voters      = Mapping.of( Address => Voter )
  @proposals   = Array.of( Proposal, num_proposals )

  @voters[@chairperson].weight = 1
end

## Give $(to_voter) the right to vote on this ballot.
## May only be called by $(chairperson).
def give_right_to_vote( to_voter )
   assert msg.sender == @chairperson && @voters[to_voter].voted? == false
   @voters[to_voter].weight = 1
end

## Delegate your vote to the voter $(to).
def delegate( to )
  sender = @voters[msg.sender]  # assigns reference
  assert sender.voted? == false

  while @voters[to].delegate != Address(0) && @voters[to].delegate != msg.sender do
    to = @voters[to].delegate
  end
  assert to != msg.sender

  sender.voted    = true
  sender.delegate = to
  delegate_to = @voters[to]
  if delegate_to.voted
    @proposals[delegate_to.vote].vote_count += sender.weight
  else
    delegate_to.weight += sender.weight
  end
end

## Give a single vote to proposal $(to_proposal).
def vote( to_proposal )
  sender = @voters[msg.sender]
  assert sender.voted? == false && to_proposal < @proposals.length
  sender.voted = true
  sender.vote  = to_proposal
  @proposals[to_proposal].vote_count += sender.weight
end

def winning_proposal
  winning_vote_count = 0
  winning_proposal   = 0
  @proposals.each_with_index do |proposal,i|
    if proposal.vote_count > winning_vote_count
      winning_vote_count = proposal.vote_count
      winning_proposal   = i
    end
  end
  winning_proposal
end
