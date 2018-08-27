module TypedRuby
  module Signatures
    class Argument
      attr_reader :name, :type

      def initialize(name:, type:)
        @name = name
        @type = type
      end
    end

    module Arguments
      class Required < Argument
      end

      class Optional < Argument
      end

      class Rest < Argument
      end

      class Post < Argument
      end

      class Keyword < Argument
      end

      class KeywordOptional < Argument
      end

      class KeywordRest < Argument
      end

      class Block < Argument
      end
    end
  end
end
