require 'yaml'

def yaml_test(obj)
  YAML.load YAML.dump(obj)
end

if RUBY_PLATFORM =~ /java/
  require 'json/pure'
  def json_test(obj)
    JSON.parse obj.to_json
  end
else
  require 'oj'
  def json_test(obj)
    Oj.load Oj.dump(obj)
  end
end

require 'msgpack'

def msgpack_test(obj)
  MessagePack.unpack MessagePack.pack(obj)
end

require 'benchmark'

ary = [1, 'dos', :tres, [4], 5.01, true, false, { 'value' => 8 }, { value: 9 }]
hsh = { '0' => 1, '1' => 'dos', '2' => :tres, '3' => [4], '4' => 5.01, '5' => true, '6' => false, '7' => { 'value' => 8 }, '8' => { value: 9 } }

n = 10_000

puts " [ Ruby #{RUBY_VERSION} (#{RUBY_PLATFORM}) ] ".center(90, '~')

puts
puts ' [ Array Accuracy ] '.center(90, '=')
y = ary.inspect;               puts 'original       | %s' % y
x = yaml_test(ary).inspect;    puts 'yaml:    [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]
x = msgpack_test(ary).inspect; puts 'msgpack: [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]
x = json_test(ary).inspect;    puts 'oj:      [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]

puts ' [ Hash Accuracy ] '.center(90, '=')
y = hsh.inspect;               puts 'original       | %s' % y
x = yaml_test(hsh).inspect;    puts 'yaml:    [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]
x = msgpack_test(hsh).inspect; puts 'msgpack: [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]
x = json_test(hsh).inspect;    puts 'oj:      [ %s ] | %s' % [(x == y ? 'T' : 'F'), x]

puts
puts ' [ Array Speed ] '.center(90, '=')
Benchmark.bmbm do |x|
  x.report('msgpack:') { n.times { msgpack_test(ary) } }
  x.report('json:   ') { n.times { json_test(ary) } }
  x.report('yaml:   ') { n.times { yaml_test(ary) } }
end

puts
puts ' [ Hash Speed ] '.center(90, '=')
Benchmark.bmbm do |x|
  x.report('msgpack:') { n.times { msgpack_test(hsh) } }
  x.report('json:   ') { n.times { json_test(hsh) } }
  x.report('yaml:   ') { n.times { yaml_test(hsh) } }
end

puts
puts 'The End!'
puts

__END__

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ [ Ruby 1.9.3 (java) ] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

=================================== [ Array Accuracy ] ===================================
original       | [1, "dos", :tres, [4], 5.01, true, false, {"value"=>8}, {:value=>9}]
yaml:    [ T ] | [1, "dos", :tres, [4], 5.01, true, false, {"value"=>8}, {:value=>9}]
msgpack: [ F ] | [1, "dos", "tres", [4], 5.01, true, false, {"value"=>8}, {"value"=>9}]
oj:      [ F ] | [1, "dos", "tres", [4], 5.01, true, false, {"value"=>8}, {"value"=>9}]
=================================== [ Hash Accuracy ] ====================================
original       | {"0"=>1, "1"=>"dos", "2"=>:tres, "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{:value=>9}}
yaml:    [ T ] | {"0"=>1, "1"=>"dos", "2"=>:tres, "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{:value=>9}}
msgpack: [ F ] | {"0"=>1, "1"=>"dos", "2"=>"tres", "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{"value"=>9}}
oj:      [ F ] | {"0"=>1, "1"=>"dos", "2"=>"tres", "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{"value"=>9}}

==================================== [ Array Speed ] =====================================
Rehearsal --------------------------------------------
msgpack:   1.070000   0.020000   1.090000 (  0.493000)
json:      6.380000   0.150000   6.530000 (  2.968000)
yaml:     13.040000   0.210000  13.250000 (  7.604000)
---------------------------------- total: 20.870000sec

               user     system      total        real
msgpack:   0.110000   0.000000   0.110000 (  0.038000)
json:      2.100000   0.050000   2.150000 (  1.008000)
yaml:      4.770000   0.090000   4.860000 (  3.702000)

===================================== [ Hash Speed ] =====================================
Rehearsal --------------------------------------------
msgpack:   0.080000   0.000000   0.080000 (  0.063000)
json:      1.760000   0.040000   1.800000 (  1.350000)
yaml:      6.400000   0.100000   6.500000 (  5.710000)
----------------------------------- total: 8.380000sec

               user     system      total        real
msgpack:   0.060000   0.000000   0.060000 (  0.048000)
json:      1.080000   0.030000   1.110000 (  1.099000)
yaml:      5.250000   0.070000   5.320000 (  5.265000)

The End!


~~~~~~~~~~~~~~~~~~~~~~~~~~ [ Ruby 1.9.3 (x86_64-darwin12.2.0) ] ~~~~~~~~~~~~~~~~~~~~~~~~~~

=================================== [ Array Accuracy ] ===================================
original       | [1, "dos", :tres, [4], 5.01, true, false, {"value"=>8}, {:value=>9}]
yaml:    [ T ] | [1, "dos", :tres, [4], 5.01, true, false, {"value"=>8}, {:value=>9}]
msgpack: [ F ] | [1, "dos", "tres", [4], 5.01, true, false, {"value"=>8}, {"value"=>9}]
oj:      [ T ] | [1, "dos", :tres, [4], 5.01, true, false, {"value"=>8}, {:value=>9}]
=================================== [ Hash Accuracy ] ====================================
original       | {"0"=>1, "1"=>"dos", "2"=>:tres, "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{:value=>9}}
yaml:    [ T ] | {"0"=>1, "1"=>"dos", "2"=>:tres, "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{:value=>9}}
msgpack: [ F ] | {"0"=>1, "1"=>"dos", "2"=>"tres", "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{"value"=>9}}
oj:      [ T ] | {"0"=>1, "1"=>"dos", "2"=>:tres, "3"=>[4], "4"=>5.01, "5"=>true, "6"=>false, "7"=>{"value"=>8}, "8"=>{:value=>9}}

==================================== [ Array Speed ] =====================================
Rehearsal --------------------------------------------
msgpack:   0.070000   0.000000   0.070000 (  0.069302)
json:      0.430000   0.000000   0.430000 (  0.435660)
yaml:      8.660000   0.120000   8.780000 (  8.779657)
----------------------------------- total: 9.280000sec

               user     system      total        real
msgpack:   0.060000   0.000000   0.060000 (  0.064192)
json:      0.420000   0.000000   0.420000 (  0.420637)
yaml:      8.680000   0.080000   8.760000 (  8.769887)

===================================== [ Hash Speed ] =====================================
Rehearsal --------------------------------------------
msgpack:   0.120000   0.010000   0.130000 (  0.119472)
json:      0.500000   0.000000   0.500000 (  0.497225)
yaml:     19.310000   0.140000  19.450000 ( 19.470249)
---------------------------------- total: 20.080000sec

               user     system      total        real
msgpack:   0.120000   0.000000   0.120000 (  0.119217)
json:      0.490000   0.000000   0.490000 (  0.496212)
yaml:     19.660000   0.110000  19.770000 ( 19.781026)

The End!