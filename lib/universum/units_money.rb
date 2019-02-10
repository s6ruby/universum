# encoding: utf-8

class Integer

  E3  = 10**3   # 1_000
  E6  = 10**6   # 1_000_000
  E9  = 10**9   # 1_000_000_000
  E12 = 10**12  # 1_000_000_000_000
  E15 = 10**15  # 1_000_000_000_000_000
  E18 = 10**18  # 1_000_000_000_000_000_000

  def e3()  self * E3; end
  def e6()  self * E6; end
  def e9()  self * E9; end
  def e12() self * E12; end
  def e15() self * E15; end
  def e18() self * E18; end


  ## todo/fix: move ethereum money units to a module and include here

  ###########
  # Ethereum money units
  #
  #  wei                     1 wei | 1
  #  kwei (babbage)        1e3 wei | 1_000
  #  mwei (lovelace)       1e6 wei | 1_000_000
  #  gwei (shannon)        1e9 wei | 1_000_000_000
  #  microether (szabo)   1e12 wei | 1_000_000_000_000
  #  milliether (finney)  1e15 wei | 1_000_000_000_000_000
  #  ether                1e18 wei | 1_000_000_000_000_000_000

  def wei()        self; end
  def kwei()       self * E3; end
  def mwei()       self * E6; end
  def gwei()       self * E9; end
  def microether() self * E12; end
  def milliether() self * E15; end
  def ether()      self * E18; end

  ########################################################
  ## alias - use alias or alias_method - why? why not?
  def babbage()   kwei; end
  def lovelace()  mwei; end
  def shannon()   gwei; end
  def szabo()     microether; end
  def finney()    milliether; end

  def microeth()  microether; end
  def millieth()  milliether; end
  def eth()       ether; end

end  # class Integer
