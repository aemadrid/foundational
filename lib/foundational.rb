lib = File.expand_path File.dirname(__FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'foundational/version'
require 'foundational/connection'
require 'foundational/conversion'
require 'msgpack'

module Foundational

  extend self

  def keyspace
    @keyspace || ['Fd']
  end

  def keyspace=(values)
    @keyspace = ::Array[values].flatten.map { |x| x.to_s }
  end

  def db
    Connection.db
  end

  def tuple_pack(*keys)
    keys = (keyspace + keys).flatten.map { |x| x.to_s }
    FDB::Tuple.pack keys
  end

  alias :tp :tuple_pack

  def tuple_unpack(key)
    FDB::Tuple.unpack(key)[1..-1]
  end

  alias :tu :tuple_unpack

  def first_key(name)
    Fd.tuple_pack name
  end

  def last_key(name)
    new_name = ::Array[name].flatten
    new_name[-1] += "\x00"
    Fd.tuple_pack new_name
  end

end

Fd = Foundational unless Object.const_defined?(:FD)
