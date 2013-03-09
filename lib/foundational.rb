lib = File.expand_path File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'foundational/version'
require 'foundational/connection'

require 'foundational/conversion'
require 'foundational/keys'

module Foundational

  extend self

  def db(api_version = 21)
    Connection.db api_version
  end

end

Fd = Foundational unless Object.const_defined?(:FD)
