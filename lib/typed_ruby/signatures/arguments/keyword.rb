module TypedRuby
  module Signatures
    class Arguments
      class Keyword < Base
        def inspect
          "#{type.inspect}, #{name}:"
        end
      end
    end
  end
end
