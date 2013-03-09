# -*- encoding: utf-8 -*-
require 'foundational'

module Foundational

  class Counter

    attr_reader :name, :workers_size

    def initialize(name, workers_size = 3)
      @name         = name.to_s
      @workers_size = workers_size
    end

    def workers_values(tr = nil)
      proc = lambda do |tr|
        (0..workers_size-1).map do |nr|
          value = tr.get key_for(nr)
          puts "workers_values : #{nr} : #{value} (#{value.class.name})"
          value ? value.to_i : 0
        end
      end
      run_proc proc, tr
    end

    def get_value(tr = nil)
      proc = lambda do |tr|
        workers_values(tr).inject(0) { |total, qty| total + qty }
      end
      run_proc proc, tr
    end

    def change_worker(worker_nr, size_change, tr = nil)
      proc = lambda do |tr|
        key       = key_for worker_nr
        old_value = tr.get key
        old_value = old_value ? old_value.to_i : 0
        new_value = old_value + size_change
        tr.set key, new_value.to_s
      end
      run_proc proc, tr
    end

    def increase(size = 1, tr = nil)
      worker_nr = rand workers_size
      change_worker worker_nr, size, tr
      get_value tr
    end

    alias :incr :increase
    alias :next_value! :increase

    def decrease(size = 1, tr = nil)
      worker_nr = rand workers_size
      change_worker worker_nr, size * -1, tr
      get_value tr
    end

    alias :decr :decrease

    def clear(tr = nil)
      proc = lambda do |tr|
        workers_size.times do |nr|
          tr.set key_for(nr), '0'
        end
      end
      run_proc proc, tr
      self
    end

    private

    def key_for(worker_nr)
      Fd.tuple_pack name, worker_nr
    end

    def run_proc(proc, tr)
      if tr
        proc.call tr
      else
        Fd.transaction { |tr| proc.call tr }
      end
    end

  end

end
