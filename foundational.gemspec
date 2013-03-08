# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foundational/version'

Gem::Specification.new do |gem|
  gem.name          = 'foundational'
  gem.version       = Foundational::VERSION
  gem.authors       = ['Adrian Madrid']
  gem.email         = %w{ aemadrid@gmail.com }
  gem.description   = %q{Having fun with FoundationDB in ruby.}
  gem.summary       = %q{Use Foundational to interface with with FoundationDB Ruby API in a more pleasant, rubyesque way. It features syntactic sugar to do the most common things you'll want to do. Plus it also includes example implementations of FoundationDB persisted array and hashes.}
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w{ lib }

  gem.add_dependency 'fdb', '~> 0.2.1'
  gem.add_dependency 'msgpack', '~> 0.5.3'

  gem.add_development_dependency 'rspec', '~> 2.8.0'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
end
