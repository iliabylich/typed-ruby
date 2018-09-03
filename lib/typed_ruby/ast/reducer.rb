require 'parser/ast/processor'

module TypedRuby
  module AST
    class Reducer
      def initialize(ast:, registry:)
        @ast = ast
        @registry = registry
      end

      def result
        substite_primitives!
        substite_arguments!
        # substitute_constants!
        # substitute_variables!
        substite_sends!

        substite_methods!

        @ast
      end

      private

      def reduced?
        @reduced
      end

      def substite_primitives!
        @ast = Substitutions::Primitives.new(registry: @registry, ast: @ast).call
      end

      def substite_arguments!
        @ast = Substitutions::Arguments.new(registry: @registry, ast: @ast).call
      end

      def substite_sends!
        @ast = Substitutions::Sends.new(registry: @registry, ast: @ast).call
      end

      def substite_methods!
        @ast = Substitutions::Methods.new(registry: @registry, ast: @ast).call
      end
    end
  end
end
