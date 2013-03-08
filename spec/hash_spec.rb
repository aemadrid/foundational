require 'spec_helper'
require 'foundational/hash'

describe Foundational::Hash do

  let(:klass) { Foundational::Hash }
  let(:name) { 'test_empty_hash' }
  let(:instance) { klass.new name }

  describe 'empty' do
    before(:each) { instance.clear }
    it { instance.should be_empty }
    it { instance.size.should == 0 }
  end

  describe 'basic' do
    before(:each) { instance.clear }
    let(:key) { 'hola' }
    let(:value) { 'hello' }

    it 'should clear' do
      instance[key] = value
      instance.clear
      instance.should be_empty
      instance.load_multimap
      instance.should be_empty
    end

    it 'should set and get' do
      instance.key?(key).should be_false
      instance[key].should be_nil
      instance[key] = value
      instance[key].should == value
    end
  end

  describe 'small' do
    before(:all) { klass.new(name).clear }
    let(:name) { 'test_small_hash' }
    let(:multimap) { { 'a' => 1, 'b' => 2, 'c' => 3 } }
    let(:subject) { klass.new_with_defaults name, multimap }
    it { should_not be_empty }
    it { subject.size.should == multimap.size }
    it { subject.should == multimap }
    it { subject['a'].should == multimap['a'] }
    it { subject['b'].should == multimap['b'] }
    it { subject['c'].should == multimap['c'] }
  end

  describe 'large' do
    before(:all) { klass.new(name).clear }
    let(:name) { 'test_large_hash' }
    let(:multimap) { (1..1000).inject({}) { |hsh, nr| hsh[nr.to_s] = "Nr. #{nr}: #{'#' * nr}"; hsh } }
    let(:subject) { klass.new_with_defaults name, multimap }
    it { should_not be_empty }
    it { subject.size.should == multimap.size }
    it { subject.should == multimap }
    it { subject['1'].should == multimap['1'] }
    it { subject['50'].should == multimap['50'] }
    it { subject['100'].should == multimap['100'] }
  end

  describe 'twins' do
    before(:all) { klass.new(name).clear }
    let(:name) { 'test_twin_hash' }
    let(:multimap) { { 'a' => 1, 'b' => 2, 'c' => 3 } }
    let(:twin_1) { klass.new_with_defaults name, multimap }
    let(:twin_2) { klass.new_with_defaults name, multimap }
    it { twin_1['a'].should == multimap['a'] }
    it { twin_1['b'].should == multimap['b'] }
    it { twin_1['c'].should == multimap['c'] }
    it { twin_1.should == twin_2 }
    it { (twin_1 <=> twin_2).should == 0 }
  end

  describe 'removing' do
    describe 'delete' do
      before(:each) { klass.new(name).clear; klass.new_with_defaults(name, multimap) }
      let(:name) { 'test_delete_hash' }
      let(:multimap) { { 'a' => 100, 'b' => 200 } }
      let(:instance) { klass.new name }

      it 'should remove existing values' do
        instance.delete('a').should == 100
        instance.should == { 'b' => 200 }
      end
      it 'should return nil for non-existing values' do
        instance.delete('z').should be_nil
        instance.delete('z') { |x| "#{x} not found" }.should == "z not found"
        instance.should == multimap
      end
    end
    describe 'delete_if' do
      before(:each) { klass.new(name).clear; klass.new_with_defaults(name, multimap) }
      let(:name) { 'test_delete_if_hash' }
      let(:multimap) { { 'a' => 100, 'b' => 200, 'c' => 300 } }
      let(:instance) { klass.new name }

      it 'should remove existing values' do
        res = instance.delete_if { |k, _| k >= 'b' }
        res.should == { 'a' => 100 }
        res.should == instance
      end
      it 'should return nil for non-existing values' do
        res = instance.delete_if { |k, _| k >= 'd' }
        res.should == multimap
        res.should == instance
      end
    end
  end

  describe 'eql' do
    let(:name) { 'test_eql_hash' }
    let(:multimap) { { 'a' => 100, 'b' => 200, 'c' => 300 } }
    let(:subject) { klass.new_with_defaults name, multimap }

    it { should == klass.new(name) }
    it { should == multimap }
    it { should == mock(:multimap => multimap) }
    it { should == mock(:to_hash => multimap) }
    it { should_not == {} }
  end

  describe 'types' do
    before(:all) { klass.new(name).clear }
    let(:name) { 'test_types_hash' }
    let(:multimap) { { '0' => 1, '1' => 'dos', '2' => :tres, '3' => [4], '4' => 5.01, '5' => true, '6' => false, '7' => { 'value' => 8 }, '8' => { value: 9 } } }
    let(:subject) { klass.new_with_defaults(name, multimap); klass.new(name) }

    it('multimap') { subject.should_not == multimap }

    it('integer') { subject['0'].should == multimap['0'] }    # OK
    it('string') { subject['1'].should == multimap['1'] }     # OK
    it('symbol') { subject['2'].should_not == multimap['2'] } # MsgPack does not encode symbols
    it('array') { subject['3'].should == multimap['3'] }      # OK
    it('float') { subject['4'].should == multimap['4'] }      # OK
    it('true') { subject['5'].should == multimap['5'] }       # OK
    it('false') { subject['6'].should == multimap['6'] }      # OK
    it('hash') { subject['7'].should == multimap['7'] }       # OK
    it('hash with symbols') { subject['8'].should_not == multimap['8'] } # MsgPack does not encode symbols
  end

  describe 'options' do
    it 'should respect encoder_type selected' do
      instance = klass.new 'test_option_set_hash', encoder_type: :yaml
      instance.encoder_type.should == :yaml
    end
    it 'should respect encoder_type selected' do
      instance = klass.new 'test_option_not_set_hash'
      instance.encoder_type.should == Fd.encoder_type
    end
  end

end