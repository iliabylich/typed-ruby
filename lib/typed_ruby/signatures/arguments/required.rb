module TypedRuby
  module Signatures
    class Arguments
      class Required < Base
        def inspect
          "#{type.inspect} #{name}"
        end

        def matches_ast?(other)
          other.type == :arg
        end
      end
    end
  end
end
