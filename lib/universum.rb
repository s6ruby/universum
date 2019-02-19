# encoding: utf-8


## stdlibs
require 'pp'         ## pretty print (pp)
require 'digest'
require 'date'
require 'time'
require 'uri'


## 3rd party gems
require 'safestruct'    # SafeArray, SafeHash, SafeStruct, etc.

## note: make Mapping an alias for Hash (lets you use Mapping.of() for Hash.of)
Mapping = Hash


## our own code
require 'universum/version'    # note: let version always go first

require 'universum/units_time'
require 'universum/units_money'

require 'universum/enum'
require 'universum/event'

require 'universum/function'
require 'universum/address'
require 'universum/type'
require 'universum/account'
require 'universum/storage'
require 'universum/contract'
require 'universum/transaction'
require 'universum/receipt'


require 'universum/universum'

require 'universum/convert'


puts Universum.banner   ## say hello
