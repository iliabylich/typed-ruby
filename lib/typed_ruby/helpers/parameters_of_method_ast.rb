module TypedRuby
  module Helpers
    class ParametersOfMethodAst < Array
      def initialize(ast)
        ast.to_a.map do |arg|
          name, _ = *arg
          case arg.type
          when :arg
            push [:req, name.to_s]
          else
            raise NotImplementedError, "Unsupported argument #{arg}"
          end
        end
      end
    end
  end
end
