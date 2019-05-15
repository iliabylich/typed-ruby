require "typed_ruby/version"

module TypedRuby
  module Helpers
    require 'typed_ruby/helpers/constant_name'
  end

  module Signatures
    require 'typed_ruby/signatures/arguments/base'
    require 'typed_ruby/signatures/arguments/block'
    require 'typed_ruby/signatures/arguments/keyword'
    require 'typed_ruby/signatures/arguments/keyword_optional'
    require 'typed_ruby/signatures/arguments/keyword_rest'
    require 'typed_ruby/signatures/arguments/optional'
    require 'typed_ruby/signatures/arguments/post'
    require 'typed_ruby/signatures/arguments/required'
    require 'typed_ruby/signatures/arguments/restarg'

    require 'typed_ruby/signatures/arguments'
    require 'typed_ruby/signatures/method'
    require 'typed_ruby/signatures/module'
    require 'typed_ruby/signatures/class'
    require 'typed_ruby/signatures/sclass'
    require 'typed_ruby/signatures/return_value'
    require 'typed_ruby/signatures/ivar'
  end

  module Types
    require 'typed_ruby/types/reduced'
    require 'typed_ruby/types/any'
    require 'typed_ruby/types/any_stmt'
    require 'typed_ruby/types/void'
    require 'typed_ruby/types/instance_of'
    require 'typed_ruby/types/unreducable'
  end

  module Parsers
    require 'typed_ruby/parsers/ruby_parser'
    require 'typed_ruby/parsers/signatures_parser'
  end

  module AST
    require 'typed_ruby/ast/reducer'
  end

  require 'typed_ruby/registry'
end
