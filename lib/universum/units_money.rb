
## todo:
##
##  add ethereum/bitcoin denominators
##
##  

class Integer

  def ether
     self * (10**18)   ## 1 ether = 1_000_000_000_000_000_000 wai   (10**18)
  end
  
  def eth() ether; end   ## alias - use alias or alias_method ?
end
