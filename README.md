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
	
### Notes

FoundationDB only saves basic values (strings) so we are using [MessagePack](http://msgpack.org/) internally to convert to and from. Strings are left untouched though. But MessagePack does not convert to/from symbols so don't try to use that either (Hash converts all keys into strings).

Also we are enforcing sub-keyspaces (namespaces for your tuple keys) inside Foundational (['Fd'] by default) so if you want another set of keyspaces just set it like so:

	```ruby
	Fd.keyspace = %w{ Some Other Keyspace }
	```
So have fun playing with FoundationDB. I'm hoping to get some more time to add more data structures.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
