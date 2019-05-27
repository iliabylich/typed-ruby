module TypedRuby
  module Signatures
    class Arguments
      class KeywordRest < Base
        def inspect
          "#{type.inspect} **#{name}"
        end
      end
    end
  end
end
