require 'parser/ast/processor'

module TypedRuby
  module AST
    class Reducer
      def initialize(ast:, registry:)
        @ast = ast
        @registry = registry
        @reduced = true
      end

      def result
        substite_primitives!
        substite_arguments!

        reduce while reduced?

        @ast
      end

      private

      def reduce
        before = @ast

        reduce_sends!

        after = @ast

        @reduced = after != before
      end

      def reduced?
        @reduced
      end

      def substite_primitives!
        @ast = Substitutions::Primitives.new(registry: @registry, ast: @ast).call
      end

      def substite_arguments!
        @ast = Substitutions::Arguments.new(registry: @registry, ast: @ast).call
      end

      def reduce_sends!
        @ast = Substitutions::Send.new(registry: @registry, ast: @ast).call
      end
    end
  end
end
