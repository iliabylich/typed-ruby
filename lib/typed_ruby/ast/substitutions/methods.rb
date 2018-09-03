module TypedRuby
  module AST
    module Substitutions
      class Methods < Scoped
        def on_def(node)
          mid, args, body = *node

          expected = current_module_signature.find_method(mid.to_s).returns
          actual = body

          return unreduced(expected, actual) unless reduced?(body)
          if actual == Types::ANY && expected != Types::ANY
            return not_any(expected, actual)
          end

          if expected >= actual
            valid(expected, actual)
          else
            puts "#{expected.inspect} >= #{actual.inspect}"
            type_error(expected, actual)
          end
        end

        def valid(expected, actual)
          'valid'
        end

        def unreduced(expected, actual)
          'unreduced'
        end

        def matches?(expected, actual)
          false
        end

        def type_error(expected, actual)
          'type_error'
        end

        def not_any(expected, actual)
          'expected NOT any, got any'
        end
      end
    end
  end
end
