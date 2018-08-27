require "typed_ruby/version"

module TypedRuby
  module Signatures
    require 'typed_ruby/signatures/arguments'
    require 'typed_ruby/signatures/method'
    require 'typed_ruby/signatures/module'
    require 'typed_ruby/signatures/class'
  end

  module Types
    require 'typed_ruby/types/any'
    require 'typed_ruby/types/void'
    require 'typed_ruby/types/instance_of'
  end

  require 'typed_ruby/registry'
end
