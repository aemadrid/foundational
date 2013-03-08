# -*- encoding: utf-8 -*-
require_relative '../../lib/foundational'

module Foundational

  class Array

    include Comparable

    attr_reader :name, :values

    extend Forwardable
    def_delegators :@values,
                   :size, :count, :each, :empty?, :index, :collect, :map, :sample, :shuffle, :uniq,
                   :first, :last

    def initialize(name)
      @name = ::Array[name].flatten.map { |x| x.to_s }
      load_values
    end

    def get(idx)
      values[idx]
    end

    alias :[] :get

    def set(idx, value)
      save_value idx, value
      @values[idx] = value
    end

    alias :[]= :set

    def load_values
      @values = []
      Fd.db.transact do |tr|
        first_key, last_key = Fd.first_key(name), Fd.last_key(name)
        tr.get_range(first_key, last_key).map { |kv| load_value kv }
      end
    end

    def add(value)
      set values.size, value
    end

    alias :<< :add

    def delete_at(idx)
      value = get idx
      if value
        Fd.db.transact do |tr|
          key = Fd.tuple_pack name, idx
          tr.clear key
          values.delete_at idx
        end
      end
      value
    end

    def delete(value)
      indexes = []
      values.each_with_index { |v, idx| indexes << idx if v == value }
      if indexes.size > 0
        Fd.db.transact do
          indexes.reverse.each { |idx| delete_at idx }
        end
        value
      else
        block_given? ? yield : nil
      end
    end

    def clear
      Fd.db.transact do |tr|
        first_key, last_key = Fd.first_key(name), Fd.last_key(name)
        tr.clear_range first_key, last_key
        @values = []
      end
    end

    def eql?(other)
      case other
        when ::Array
          values == other
        when self.class
          name == other.name
        else
          (other.respond_to?(:values) && values == other.values) ||
            (other.respond_to?(:to_ary) && values == other.to_ary)
      end
    end

    alias :== :eql?

    def <=>(other)
      name <=> other.name
    end

    def self.new_with_defaults(name, *defaults)
      obj = new name
      defaults.each_with_index { |value, idx| obj[idx] ||= value }
      obj
    end

    private

    def load_value(kv)
      idx   = Fd.tuple_unpack(kv.key).last.to_i
      value = kv.value
      value = Fd.decode_value(value) if value[0, 1] == "\x01"
      @values[idx] = value
    end

    def save_value(idx, value)
      value = Fd.encode_value(value) unless value.is_a?(String)
      key = Fd.tuple_pack name, idx
      Fd.db.transact { |tr| tr.set key, value }
    end

  end

end