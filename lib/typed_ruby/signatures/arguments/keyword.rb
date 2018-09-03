module TypedRuby
  module Signatures
    class Arguments
      class Keyword < Base
        def inspect
          "#{name}:<#{type.inspect}>"
        end
      end
    end
  end
end
