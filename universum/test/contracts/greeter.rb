# encoding: utf-8

######################
# Greeter Contract

def setup( greeting )
  @owner    = msg.sender
  @greeting = greeting
end

def greet
  @greeting
end

def kill
  selfdestruct( msg.sender )  if msg.sender == @owner
end
