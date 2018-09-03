module TypedRuby
  module Signatures
    class Arguments
      class Rest < Base
        def inspect
          "*#{name}<#{type.inspect}>"
        end
      end
    end
  end
end
