module TypedRuby
  module Signatures
    class Arguments
      class Required < Base
        def inspect
          "#{name}<#{type.inspect}>"
        end

        def matches_ast?(other)
          other.type == :arg
        end
      end
    end
  end
end
