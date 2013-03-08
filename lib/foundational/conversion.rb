module Foundational

  extend self

  def encoding_mark
    @encoding_mark || "\x01"
  end

  def encoding_mark=(value)
    @encoding_mark = value
  end

  def encoder_type
    @encoder_type || :msgpack
  end

  def encoder_type=(value)
    @encoder_type = value
  end

  def encode_value(value, converter_type = encoder_type)
    return value if value.is_a? String
    encoding_mark + send("#{converter_type}_encode_value", value)
  end

  alias :enc :encode_value

  def decode_value(string, converter_type = encoder_type)
    return string unless string[0, encoding_mark.size] == encoding_mark
    value = string[encoding_mark.size..-1]
    send "#{converter_type}_decode_value", value
  end

  alias :dec :decode_value

end

require 'foundational/conversion/json'
require 'foundational/conversion/msgpack'
require 'foundational/conversion/yaml'
