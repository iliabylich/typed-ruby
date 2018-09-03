module TypedRuby
  module AST
    module Substitutions
      class Methods < Scoped
        def on_def(node)
          mid, args, body = *node

          expected = current_module_signature.find_method(mid.to_s)
          actual = body

          return unreduced(expected, actual) unless reduced?(body)
          return type_error(expected, actual) unless matches?(expected, actual)
          valid(expected, actual)
        end

        def unreduced(expected, actual)
          binding.pry
        end

        def matches?(expected, actual)
          false
        end

        def type_error(expected, actual)
          'type_error'
        end
      end
    end
  end
end
