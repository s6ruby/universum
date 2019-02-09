
## add to Mapping.of()
## assume args[0] is a hash e.g. { Address => Money }
## todo/fix: find a better way to "unwrap" key/value pair
recs = args[0].to_a

@type_key   =  recs[0][0]
@type_value =  recs[0][1]




class SafeHash

  ## e.g.
  ##  Mapping.of( Address => Money )

  ##   note: need to create new class!! for every mapping
  ##     make type_key class and
  ##          type_value class  into class instance variables
  ##     that can get used by zero
  ##       self.new returns a Hash.new/SafeHash.new like object

  def self.build_class( type_key, type_value )
    ## fix: todo/cache klass if key/value classes are the same (and reuse)
    klass = Class.new( SafeHash )
    klass.class_eval( <<RUBY )
      def self.type_key
        @type_key   ||= #{type_key}
      end
      def self.type_value
        @type_value ||= #{type_value}
      end
      def self.zero
        @zero       ||= new
      end
RUBY
    klass
  end


  def initialize
    ## todo/check: if hash works if value is a (nested) hash
    @h  = {}
  end

  def []=(key, value)
    @h[key] = value
  end

  def [](key)
    item = @h[ key ]
    if item.nil?

      if self.class.type_value.is_a?(Struct) ||
         self.class.type_value.is_a?(SafeArray) ||
         self.class.type_value.is_a?(SafeHash)  ||
        ## note: use a dup(licated) unfrozen copy of the zero object
        ##    changes to the object MUST be possible (new "empty" modifable object expected)
       item = @h[ key ] = self.class.type_value.zero.dup
     else  # assume value semantics e.g. Integer, Bool, etc. zero values gets replaced
       item = @h[ key ] = self.class.type_value.zero
     end
    end
    item
  end

end # class SafeHash
