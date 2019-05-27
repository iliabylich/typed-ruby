module TypedRuby
  module Signatures
    class Arguments
      class Optional < Base
        def inspect
          "#{type.inspect} #{name} = _"
        end
      end
    end
  end
end
