# Foundational

Use [Foundational](https://github.com/aemadrid/foundational) to interface with with [FoundationDB](http://www.foundationdb.com/) [Ruby API](http://www.foundationdb.com/documentation/beta1/api-ruby.html) in a more pleasant, rubyesque way. It features syntactic sugar to do the most common things you'll want to do. Plus it also includes example implementations of FoundationDB persisted array and hashes.

## Installation

Add this line to your application's Gemfile:

    gem 'foundational'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install foundational

## Usage

### Convenience Methods

Instead of:

```ruby
require 'fdb'
FDB.api_version 21
db = FDB.open
```
	
Let's do this:

```ruby
require 'foundational'
Fd.open
```
	
And then you can access the db from everywhere:

```ruby
Fd.db.transact do |tr|
  tr['a'] = 'A'
  tr['b'] = 'B'
end
```

Some tuples:

```ruby
FDB::Tuple.unpack(FDB::Tuple.pack([1, 2, 3]))
# becomes
Fd.tuple_unpack(Fd.tuple_pack(1, 2, 3))
# or even better
Fd.tu(Fd.tp(1, 2, 3))
```

### Persisted Array

Let's say you want to turn your simple, one level Array into a FoundationDB persisted Array, then:

```ruby
ary = Fd::Array.new 'simple_array'
ary << 1
ary << 'dos'
ary << [3]
# some time later
ary = Fd::Array.new 'simple_array'
# => [1, 'dos', [3]]
```

### Persisted Hash

Very similar to what you can do with a FoundationDB persisted Hash:

```ruby
hsh = Fd::Hash.new 'simple_hash'
hsh['a'] = 1
hsh['b'] = 'dos'
hsh['c'] = [3]
# some time later
hsh = Fd::Hash.new 'simple_hash'
# => { 'a' => 1, 'b' => 'dos', 'c' => [3] }
```
	
### Notes


#### Conversion 
FoundationDB only saves basic values (strings) so we are using several serializers to choose from: [MessagePack](http://msgpack.org/) (default, fastest), [YAML](http://ruby-doc.org/stdlib-1.9.3/libdoc/yaml/rdoc/YAML.html) and [JSON](https://github.com/intridea/multi_json) internally to convert to and from. Strings are left untouched though. You can choose your converter but be careful because some don't translate symbols or complex Ruby objects (MessagePack, JSON). As always, you need to choose between speed and features.

#### Sub-Keyspaces
We are enforcing sub-keyspaces (namespaces for your tuple keys) inside Foundational (['Fd'] is the default keyspace) so if you want another set of keyspaces just set it like so:

```ruby
Fd.keyspace = %w{ Some Other Keyspace }
```

#### The End
Be excellent to each other. Party on, dudes!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
