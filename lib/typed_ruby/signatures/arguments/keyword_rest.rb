module TypedRuby
  module Signatures
    class Arguments
      class KeywordRest < Base
        def inspect
          "**#{name}<#{type.inspect}>"
        end
      end
    end
  end
end
