module TypedRuby
  module Signatures
    class Arguments
      class Restarg < Base
        def inspect
          "#{type.inspect} *#{name}"
        end
      end
    end
  end
end
