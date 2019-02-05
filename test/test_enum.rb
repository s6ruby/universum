

State = Enum.new( :fundraising, :expired_refund, :successful )
pp State

pp state = State.fundraising
pp state.fundraising?
pp state.expired_refund?
pp state.successful?
pp state = State.expired_refund
pp state.fundraising?
pp state.expired_refund?
pp state.successful?
