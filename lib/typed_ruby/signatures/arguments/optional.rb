module TypedRuby
  module Signatures
    class Arguments
      class Optional < Base
        def inspect
          "#{name}#{type.inspect} = ?"
        end
      end
    end
  end
end
