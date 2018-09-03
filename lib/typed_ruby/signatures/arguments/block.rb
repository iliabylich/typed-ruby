module TypedRuby
  module Signatures
    class Arguments
      class Block < Base
        def inspect
          "&#{name}<#{type.inspect}>"
        end
      end
    end
  end
end
