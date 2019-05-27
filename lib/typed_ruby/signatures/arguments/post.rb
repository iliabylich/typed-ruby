module TypedRuby
  module Signatures
    class Arguments
      class Post < Base
        def inspect
          "#{type.inspect} &#{name}"
        end
      end
    end
  end
end
