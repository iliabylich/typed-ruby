module TypedRuby
  module Signatures
    class Arguments
      class Post < Base
        def inspect
          "#{name}<#{type.inspect}>"
        end
      end
    end
  end
end
