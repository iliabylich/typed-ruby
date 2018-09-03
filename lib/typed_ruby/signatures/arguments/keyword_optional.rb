module TypedRuby
  module Signatures
    class Arguments
      class KeywordOptional < Base
        def inspect
          "#{name}: ?<#{type.inspect}>"
        end
      end
    end
  end
end
