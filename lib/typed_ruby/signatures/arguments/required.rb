module TypedRuby
  module Signatures
    class Arguments
      class Required < Base
        def inspect
          "#{name}<#{type.inspect}>"
        end

        def =~(other)
          case other
          when ::Parser::AST::Node
            other.type == :arg
          when Types::Reduced
            type >= other
          else
            raise 'bug'
          end
        end
      end
    end
  end
end
