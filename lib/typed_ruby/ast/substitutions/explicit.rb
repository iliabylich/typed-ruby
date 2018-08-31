module TypedRuby
  module AST
    module Substitutions
      class Explicit < Base
        def initialize(from:, to:)
          @from = from
          @to   = to

          define_singleton_method(:"on_#{from.type}") do |node|
            node == @from ? replace(node, @to) : node
          end
        end

        def call(ast)
          process(ast)
        end
      end
    end
  end
end
