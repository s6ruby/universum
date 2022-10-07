# encoding: utf-8


##
## note: Universum is a class (and NOT a module for now)

class Universum

  MAJOR = 0
  MINOR = 5
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "universum/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )}"
  end

end # module Universum
