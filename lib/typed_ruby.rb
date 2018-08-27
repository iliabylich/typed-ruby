require "typed_ruby/version"

module TypedRuby
  module Signatures
    require 'typed_ruby/signatures/arguments'
    require 'typed_ruby/signatures/method'
    require 'typed_ruby/signatures/module'
    require 'typed_ruby/signatures/class'
  end

  module Types
    ANY = Object.new.freeze
    VOID = Object.new.freeze
    require 'typed_ruby/types/instance_of'
  end

  require 'typed_ruby/registry'
end
