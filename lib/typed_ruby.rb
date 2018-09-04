require "typed_ruby/version"

module TypedRuby
  module Helpers
    require 'typed_ruby/helpers/constant_name'
    require 'typed_ruby/helpers/reduced_arglist'
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
    require 'typed_ruby/signatures/arguments/rest'

    require 'typed_ruby/signatures/arguments'
    require 'typed_ruby/signatures/method'
    require 'typed_ruby/signatures/module'
    require 'typed_ruby/signatures/class'
    require 'typed_ruby/signatures/sclass'
  end

  module Types
    require 'typed_ruby/types/reduced'
    require 'typed_ruby/types/any'
    require 'typed_ruby/types/void'
    require 'typed_ruby/types/instance_of'
  end

  module AST
    require 'typed_ruby/ast/ruby_parser'
    require 'typed_ruby/ast/reducer'

    module Substitutions
      require 'typed_ruby/ast/substitutions/base'
      require 'typed_ruby/ast/substitutions/scoped'

      require 'typed_ruby/ast/substitutions/primitives'
      require 'typed_ruby/ast/substitutions/arguments'
      require 'typed_ruby/ast/substitutions/explicit'
      require 'typed_ruby/ast/substitutions/sends'
      require 'typed_ruby/ast/substitutions/methods'
    end
  end

  require 'typed_ruby/registry'
end
