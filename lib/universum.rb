# encoding: utf-8


## stdlibs
require 'pp'         ## pretty print (pp)
require 'digest'
require 'date'
require 'time'
require 'uri'



## our own code
require 'universum/version'    # note: let version always go first

require 'universum/units_time'
require 'universum/units_money'

require 'universum/safe_array'
require 'universum/safe_hash'

require 'universum/enum'
require 'universum/event'

require 'universum/universum'



puts Universum.banner   ## say hello
