require 'spec_helper'

describe Foundational do

  let(:values) { [1, 'dos', :tres, [4], 5.01, true, false, { 'value' => 8 }, { value: 9 }] }

  describe 'json' do
    let(:encoded) { %w(1 "dos" "tres" [4] 5.01 true false {"value":8} {"value":9}) }
    describe 'encode' do
      let(:meth) { :json_encode_value }
      let(:results) { values.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == encoded[0] }
      it('string') { results[1].should == encoded[1] }
      it('symbol') { results[2].should == encoded[2] }
      it('array') { results[3].should == encoded[3] }
      it('float') { results[4].should == encoded[4] }
      it('true') { results[5].should == encoded[5] }
      it('false') { results[6].should == encoded[6] }
      it('hash') { results[7].should == encoded[7] }
      it('hash with symbols') { results[8].should == encoded[8] }
    end
    describe 'decode' do
      let(:meth) { :json_decode_value }
      let(:results) { encoded.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == values[0] }
      it('string') { results[1].should == values[1] }
      it('symbol') { results[2].should == 'tres' } # Different: JSON does not encode Symbols
      it('array') { results[3].should == values[3] }
      it('float') { results[4].should == values[4] }
      it('true') { results[5].should == values[5] }
      it('false') { results[6].should == values[6] }
      it('hash') { results[7].should == values[7] }
      it('hash with symbols') { results[8].should == { 'value' => 9 } } # Different: JSON does not encode Symbols
    end
  end

  describe 'msgpack' do
    let(:encoded) { %W{ \x01 \xA3dos \xA4tres \x91\x04 \xCB@\x14\n=p\xA3\xD7\n \xC3 \xC2 \x81\xA5value\b \x81\xA5value\t } }
    describe 'encode' do
      let(:meth) { :msgpack_encode_value }
      let(:results) { values.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == encoded[0] }
      it('string') { results[1].should == encoded[1] }
      it('symbol') { results[2].should == encoded[2] }
      it('array') { results[3].should == encoded[3] }
      it('float') { results[4].should == encoded[4] }
      it('true') { results[5].should == encoded[5] }
      it('false') { results[6].should == encoded[6] }
      it('hash') { results[7].should == encoded[7] }
      it('hash with symbols') { results[8].should == encoded[8] }
    end
    describe 'decode' do
      let(:meth) { :msgpack_decode_value }
      let(:results) { encoded.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == values[0] }
      it('string') { results[1].should == values[1] }
      it('symbol') { results[2].should == 'tres' } # Different: MessagePack does not encode Symbols
      it('array') { results[3].should == values[3] }
      it('float') { results[4].should == values[4] }
      it('true') { results[5].should == values[5] }
      it('false') { results[6].should == values[6] }
      it('hash') { results[7].should == values[7] }
      it('hash with symbols') { results[8].should == { 'value' => 9 } } # Different: MessagePack does not encode Symbols
    end
  end

  describe 'yaml' do
    let(:encoded) do
      if RUBY_PLATFORM =~ /java/
        ["--- 1\n", "--- dos\n", "--- :tres\n", "---\n- 4\n", "--- 5.01\n", "--- true\n", "--- false\n", "---\nvalue: 8\n", "---\n:value: 9\n",]
      else
        ["--- 1\n...\n", "--- dos\n...\n", "--- :tres\n...\n", "---\n- 4\n", "--- 5.01\n...\n", "--- true\n...\n", "--- false\n...\n", "---\nvalue: 8\n", "---\n:value: 9\n",]
      end
    end
    describe 'encode' do
      let(:meth) { :yaml_encode_value }
      let(:results) { values.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == encoded[0] }
      it('string') { results[1].should == encoded[1] }
      it('symbol') { results[2].should == encoded[2] }
      it('array') { results[3].should == encoded[3] }
      it('float') { results[4].should == encoded[4] }
      it('true') { results[5].should == encoded[5] }
      it('false') { results[6].should == encoded[6] }
      it('hash') { results[7].should == encoded[7] }
      it('hash with symbols') { results[8].should == encoded[8] }
    end
    describe 'decode' do
      let(:meth) { :yaml_decode_value }
      let(:results) { encoded.map { |x| Fd.send meth, x } }

      it('integer') { results[0].should == values[0] }
      it('string') { results[1].should == values[1] }
      it('symbol') { results[2].should == values[2] }
      it('array') { results[3].should == values[3] }
      it('float') { results[4].should == values[4] }
      it('true') { results[5].should == values[5] }
      it('false') { results[6].should == values[6] }
      it('hash') { results[7].should == values[7] }
      it('hash with symbols') { results[8].should == values[8] }
    end
  end

end