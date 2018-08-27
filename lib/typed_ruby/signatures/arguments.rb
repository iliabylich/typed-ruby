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
        def inspect
          "#{name}<#{type.inspect}>"
        end
      end

      class Optional < Argument
        def inspect
          "#{name}#{type.inspect} = ?"
        end
      end

      class Rest < Argument
        def inspect
          "*#{name}<#{type.inspect}>"
        end
      end

      class Post < Argument
        def inspect
          "#{name}<#{type.inspect}>"
        end
      end

      class Keyword < Argument
        def inspect
          "#{name}:<#{type.inspect}>"
        end
      end

      class KeywordOptional < Argument
        def inspect
          "#{name}: ?<#{type.inspect}>"
        end
      end

      class KeywordRest < Argument
        def inspect
          "**#{name}<#{type.inspect}>"
        end
      end

      class Block < Argument
        def inspect
          "&#{name}<#{type.inspect}>"
        end
      end
    end
  end
end
