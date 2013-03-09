require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'foundational/counter'

describe Foundational::Counter do

  let(:klass) { Foundational::Counter }
  let(:workers_size) { 3 }
  let(:instance) { klass.new(name, workers_size) }

  describe 'new' do
    let(:name) { 'test_empty_counter' }
    it { instance.get_value.should == 0 }
    it { instance.workers_size.should == workers_size }
  end

  describe 'increase' do
    let(:name) { 'test_incr_counter' }
    before(:each) { instance.clear }
    it 'should work on its own transaction' do
      instance.get_value.should == 0
      instance.increase(1).should == 1
      instance.get_value.should == 1
      instance.increase(3).should == 4
      instance.get_value.should == 4
    end
    it 'should work on a known transaction' do
      Fd.transaction do |tr|
        instance.get_value(tr).should == 0
        instance.increase(1, tr).should == 1
        instance.get_value(tr).should == 1
        instance.increase(3, tr).should == 4
        instance.get_value(tr).should == 4
      end
    end
  end

  describe 'decrease' do
    let(:name) { 'test_decr_counter' }
    before(:each) { instance.clear }
    it 'should work on its own transaction' do
      instance.get_value.should == 0
      instance.decrease(1).should == -1
      instance.get_value.should == -1
      instance.decrease(3).should == -4
      instance.get_value.should == -4
    end
    it 'should work on a known transaction' do
      Fd.transaction do |tr|
        instance.get_value(tr).should == 0
        instance.decrease(1, tr).should == -1
        instance.get_value(tr).should == -1
        instance.decrease(3, tr).should == -4
        instance.get_value(tr).should == -4
      end
    end
  end

  describe 'clear' do
    let(:name) { 'test_clear_counter' }
    before(:each) { instance.clear }
    it 'should work on its own transaction' do
      instance.get_value.should == 0
      instance.increase(1).should == 1
      instance.get_value.should == 1
      instance.clear.should == instance
      instance.get_value.should == 0
    end
    it 'should work on a known transaction' do
      Fd.transaction do |tr|
        instance.get_value(tr).should == 0
        instance.increase(1, tr).should == 1
        instance.get_value(tr).should == 1
        instance.clear(tr).should == instance
        instance.get_value(tr).should == 0
      end
    end
  end

end