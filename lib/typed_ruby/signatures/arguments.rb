module TypedRuby
  module Signatures
    class Argument
      attr_reader :name, :type

      def initialize(name:, type:)
        @name = name
        @type = type
      end
    end

    class Arguments
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

      include Enumerable

      def initialize(list = []) # TODO: kw/block
        @list = list

        @req = list.grep(Required)
        @opt = list.grep(Optional)
        @rest = list.grep(Block).first
        @post = list.grep(Post)
      end

      def inspect
        '(' + [@req, @opt, @rest, @post].map(&:inspect).join(', ') + ')'
      end

      def each
        return to_enum(:each) unless block_given?
        @list.each { |e| yield e }
      end

      def matches?(ast)
        Helpers::ParametersOfMethodAst.new(ast) == Helpers::ParametersOfMethodSignature.new(self)
      end

      def matches_args?(ast)
      end

      class Any < self
        def inspect
          '...AnyArguments'
        end
      end

      ANY = Any.new
    end
  end
end
