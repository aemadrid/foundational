begin
  require 'yaml'

  module Foundational

    extend self

    def yaml_encode_value(value)
      YAML.dump value
    end

    def yaml_decode_value(string)
      YAML.load string
    end

  end
rescue LoadError
  puts "[Foundational] No YAML encoding support ..."
end
