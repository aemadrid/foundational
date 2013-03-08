require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'foundational/array'

describe Foundational::Array do

  let(:klass) { Foundational::Array }
  let(:name) { 'test_empty_array' }
  let(:instance) { klass.new name }

  describe 'empty' do
    before(:each) { instance.clear }
    it { instance.should be_empty }
    it { instance.size.should == 0 }
  end

  describe 'basic' do
    before(:each) { instance.clear }
    let(:value) { 'hello' }

    it 'should add' do
      instance.add value
      instance[0].should == value
      instance.first.should == value
    end

    it 'should clear' do
      instance.add value
      instance.clear
      instance.should be_empty
      instance.load_values
      instance.should be_empty
    end

    it 'should set and get' do
      instance.set 0, value
      instance.get(0).should == value
    end
  end

  describe 'small' do
    let(:name) { 'test_small_array' }
    let(:values) { %w{ a b c d e f } }
    let(:subject) { klass.new_with_defaults name, *values }
    it { should_not be_empty }
    it { subject.size.should == values.size }
    it { subject.should == values }
    it { subject.first.should == values.first }
    it { subject[1].should == values[1] }
    it { subject.last.should == values.last }
  end

  describe 'large' do
    let(:name) { 'test_large_array' }
    let(:values) { (1..1000).map { |nr| "Nr. #{nr}: #{'#' * nr}" } }
    let(:subject) { klass.new_with_defaults name, *values }
    it { should_not be_empty }
    it { subject.size.should == values.size }
    it { subject.should == values }
    it { subject.first.should == values.first }
    it { subject[1].should == values[1] }
    it { subject.last.should == values.last }
  end

  describe 'twins' do
    let(:name) { 'test_twin_array' }
    let(:values) { %w{ a b c } }
    let(:twin_1) { klass.new_with_defaults name, *values }
    let(:twin_2) { klass.new_with_defaults name, *values }
    it { twin_1.should == twin_2 }
    it { (twin_1 <=> twin_2).should == 0 }
  end

  describe 'removing' do
    describe 'delete_at' do
      before(:all) { klass.new(name).clear }
      let(:name) { 'test_delete_at_array' }
      let(:instance) { klass.new_with_defaults name, *%w( ant bat cat dog ) }
      it 'should remove existing values' do
        instance.delete_at(2).should == 'cat'
        instance.should == %w( ant bat dog )
      end
      it 'should return nil for non-existing values' do
        instance.delete_at(99).should be_nil
      end
    end
    describe 'delete' do
      before(:all) { klass.new(name).clear }
      let(:name) { 'test_delete_x_array' }
      let(:instance) { klass.new_with_defaults name, *%w( a b b b c ) }
      it 'should remove existing values' do
        instance.delete('b').should == 'b'
        instance.should == %w( a c )
      end
      it 'should return nil for non-existing values' do
        instance.delete('z').should be_nil
        instance.delete('z') { 'not_found' }.should == 'not_found'
      end
    end
  end

  describe 'eql' do
    let(:name) { 'test_eql_array' }
    let(:values) { %w{ a b c } }
    let(:subject) { klass.new_with_defaults name, *values }

    it { should == klass.new(name) }
    it { should == values }
    it { should == mock(:values => values) }
    it { should == mock(:to_ary => values) }
    it { should_not == [] }
  end

  describe 'types' do
    let(:name) { 'test_types_array' }
    let(:values) { [1, 'dos', :tres, [4], 5.01, true, false, { 'value' => 8 }, { value: 9 }] }
    let(:subject) { klass.new_with_defaults(name, *values); klass.new name }

    it('values') { subject.should_not == values }

    it('integer') { subject[0].should == values[0] }    # OK
    it('string') { subject[1].should == values[1] }     # OK
    it('symbol') { subject[2].should_not == values[2] } # MsgPack does not encode symbols
    it('array') { subject[3].should == values[3] }      # OK
    it('float') { subject[4].should == values[4] }      # OK
    it('true') { subject[5].should == values[5] }       # OK
    it('false') { subject[6].should == values[6] }      # OK
    it('hash') { subject[7].should == values[7] }       # OK
    it('hash with symbols') { subject[8].should_not == values[8] } # MsgPack does not encode symbols
  end

  describe 'options' do
    it 'should respect encoder_type selected' do
      instance = klass.new 'test_option_set_array', converter_type: :yaml
      instance.converter_type.should == :yaml
    end
    it 'should respect encoder_type selected' do
      instance = klass.new 'test_option_not_set_array'
      instance.converter_type.should == Fd.converter_type
    end
  end

end