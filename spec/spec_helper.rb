unless Object.const_defined? :SPEC_HELPER_LOADED

  begin
    require 'simplecov'
    SimpleCov.start
    SimpleCov.start do
      add_group 'Libs', 'lib'
      add_group 'Specs', 'spec'
    end
  rescue LoadError
    puts 'SimpleCov not available, skipping coverage...'
  end

  require 'bundler/setup'
  lib = File.expand_path File.dirname(__FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

  require 'foundational'
  Fd.db

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered                = true
    config.filter_run :focus
    config.order = 'random'
    config.filter_run_excluding :broken => true, :skipped => true
  end

  Object.const_set :SPEC_HELPER_LOADED, true
end