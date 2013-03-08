# -*- encoding: utf-8 -*-
require_relative '../../lib/foundational'

module Foundational

  class Hash

    include Comparable

    attr_reader :name, :multimap, :options

    extend Forwardable
    def_delegators :@multimap,
                   :size, :count, :each, :empty?, :collect, :map, :keys, :values

    def initialize(name, options = {})
      @name = name.to_s
      @options = options
      load_multimap
    end

    def encoder_type
      @options[:encoder_type] || Fd.encoder_type
    end

    def get(key)
      multimap[key.to_s]
    end

    alias :[] :get

    def set(key, value)
      save_value key, value
      @multimap[key.to_s] = value
    end

    alias :[]= :set

    def key?(key)
      multimap.key? key.to_s
    end

    def load_multimap
      @multimap = {}
      Fd.db.transact do |tr|
        first_key, last_key = Fd.first_key(name), Fd.last_key(name)
        tr.get_range(first_key, last_key).map { |kv| load_value kv }
      end
    end

    def delete(key)
      if key? key
        value = get key
        Fd.db.transact do |tr|
          tr.clear Fd.tuple_pack(name, key)
          multimap.delete key.to_s
        end
      else
        block_given? ? yield(key) : nil
      end
    end

    def delete_if
      Fd.db.transact do |tr|
        multimap.each do |k, v|
          res = yield k, v
          delete(k) if res
        end
      end
      self
    end

    def clear
      Fd.db.transact do |tr|
        first_key, last_key = Fd.first_key(name), Fd.last_key(name)
        tr.clear_range first_key, last_key
        @multimap = {}
      end
    end

    def eql?(other)
      case other
        when ::Hash
          multimap == other
        when self.class
          name == other.name
        else
          (other.respond_to?(:multimap) && multimap == other.multimap) ||
            (other.respond_to?(:to_hash) && multimap == other.to_hash)
      end
    end

    alias :== :eql?

    def <=>(other)
      name <=> other.name
    end

    def self.new_with_defaults(name, defaults = {})
      obj = new name
      defaults.each { |key, value| obj[key] ||= value }
      obj
    end

    private

    def load_value(kv)
      key   = Fd.tuple_unpack(kv.key).last
      value = kv.value
      value = Fd.decode_value value, encoder_type
      @multimap[key] = value
    end

    def save_value(key, value)
      value = Fd.encode_value value, encoder_type
      tuple = Fd.tuple_pack name, key.to_s
      Fd.db.transact { |tr| tr.set tuple, value }
    end

  end

end