
## todo:
##
## add 1.week, 2.weeks
##  1.day, 2.days
##  1.hour, 2.hous
##  min, minutes, minute
##  sec, second, seconds  (does NOTHING - timestamp is second based )

class Integer

  def day
     self * 24*60*60   # 24 hours * 60 minutes * 60 seconds
  end
  
  def days() day; end   ## alias - use alias or alias_method ?
end
