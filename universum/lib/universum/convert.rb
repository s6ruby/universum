# encoding: utf-8


## note: put all "global" Kernel converter methods into Kernel module
module Kernel

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

end # module Kernel
