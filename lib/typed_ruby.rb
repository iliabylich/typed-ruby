require "typed_ruby/version"

module TypedRuby
  module Helpers
    require 'typed_ruby/helpers/constant_name'
    require 'typed_ruby/helpers/method_signature_match'
  end

  module Signatures
    require 'typed_ruby/signatures/arguments'
    require 'typed_ruby/signatures/method'
    require 'typed_ruby/signatures/module'
    require 'typed_ruby/signatures/class'
    require 'typed_ruby/signatures/sclass'
  end

  module Types
    require 'typed_ruby/types/any'
    require 'typed_ruby/types/void'
    require 'typed_ruby/types/instance_of'
  end

  module AST
    require 'typed_ruby/ast/parser'
    require 'typed_ruby/ast/reducer'

    module Substitutions
      require 'typed_ruby/ast/substitutions/base'
      require 'typed_ruby/ast/substitutions/primitives'
      require 'typed_ruby/ast/substitutions/arguments'
      require 'typed_ruby/ast/substitutions/explicit'
    end
  end

  require 'typed_ruby/registry'
end
