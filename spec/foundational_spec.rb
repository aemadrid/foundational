require 'spec_helper'

describe Foundational do

  it { Foundational.should == Fd }
  let(:keys) { %w{ a b c } }
  let(:keys_packed) { "\x01Fd\x00\x01a\x00\x01b\x00\x01c\x00" }

  describe '#keyspace' do
    it { Fd.keyspace.should == ['Fd'] }
    it 'should change keyspace' do
      old_keyspace = Fd.keyspace
      Fd.keyspace  = %w(Great App)
      Fd.keyspace.should == %w(Great App)
      Fd.keyspace = old_keyspace
      Fd.keyspace.should == old_keyspace
    end
  end

  describe '#tuple_pack' do
    it { Fd.tuple_pack(*keys).should == keys_packed }
  end

  describe '#tuple_unpack' do
    it 'should raise an exception on JRuby' do
      if RUBY_PLATFORM =~ /java/
        expect { Fd.tuple_unpack(keys_packed) }.to raise_error(RegexpError)
      else
        Fd.tuple_unpack(keys_packed).should == keys
      end
    end
  end

end