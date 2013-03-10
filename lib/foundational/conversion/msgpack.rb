begin
  require 'msgpack'

  module Foundational

    extend self

    def msgpack_decode_value(string)
      MessagePack.unpack string
    end

    def msgpack_encode_value(value)
      MessagePack.pack value
    end
  end
rescue LoadError
  puts "[Foundational] No MessagePack encoding support ..."
end
