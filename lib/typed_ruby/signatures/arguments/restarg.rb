module TypedRuby
  module Signatures
    class Arguments
      class Restarg < Base
        def inspect
          "*#{name}<#{type.inspect}>"
        end
      end
    end
  end
end