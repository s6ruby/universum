# encoding: utf-8

###
# e.g. use Address(0) 

def Address( arg )
  if arg == 0 || arg == '0x0' || arg == '0x0000'
    '0x0000'   ## note: return a string for now and NOT (typed) Address.zero
  else
    ## assume string (hex) address
    ##  pass through for now
    ##
    ##   use an address lookup in the future - why? why not?
    ##    Address.find_by_address( arg )
    arg
  end
end



###
## todo - add a global method_missing handler for (auto-)adding converters for Structs - why? why not?
##  e.g. how to auto-create   Vote(0) for Vote.zero  or Bet(0) for Bet.zero and so on - why? why not?
##
##   def Vote( arg ) Vote.zero; end  

