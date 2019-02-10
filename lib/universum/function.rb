# encoding: utf-8

########################################
# builtin "global" functions

def sha256( *args )
  ## note: allow multiple args (string)
  ##   all args will get auto-joined (with no padding)
  Digest::SHA256.hexdigest( args.join )
end
