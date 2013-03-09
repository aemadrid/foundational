module Foundational

  extend self

  def keyspace
    @keyspace || ['Fd']
  end

  def keyspace=(values)
    @keyspace = ::Array[values].flatten.map { |x| x.to_s }
  end

  def tuple_pack(*keys)
    keys = (keyspace + keys).flatten.map { |x| x.to_s }
    FDB::Tuple.pack keys
  end

  alias :tp :tuple_pack

  def tuple_unpack(key)
    FDB::Tuple.unpack(key)[keyspace.size..-1]
  end

  alias :tu :tuple_unpack

  def first_key(name)
    Fd.tuple_pack name
  end

  def last_key(name)
    new_name = ::Array[name].flatten
    new_name[-1] = new_name.to_s + "\x00"
    Fd.tuple_pack new_name
  end

  def get_range_for(name, tr = nil)
    if tr
      yield tr.get_range first_key(name), last_key(name)
    else
      Fd.transaction do |tr|
        yield tr.get_range first_key(name), last_key(name)
      end
    end
  end

  def transaction
    Fd.db.transact do |tr|
      yield tr
    end
  end

  alias :tr :transaction

end
