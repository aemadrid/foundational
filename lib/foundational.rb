lib = File.expand_path File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'foundational/version'
require 'foundational/connection'

module Foundational

  extend self

  def db
    Connection.db
  end

end

require 'foundational/conversion'
require 'foundational/keys'

Fd = Foundational unless Object.const_defined?(:FD)
