begin
  require 'multi_json'

  module Foundational

    extend self

    def json_encode_value(value)
      MultiJson.dump value
    end

    def json_decode_value(string)
      MultiJson.load string
    end

  end
rescue LoadErrot
  puts "[Foundational] No JSON encoding support ..."
end

