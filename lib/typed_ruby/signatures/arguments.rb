module TypedRuby
  module Signatures
    class Arguments
      def initialize(list = []) # TODO: kw/block
        @list = list

        # @req = list.grep(Required)
        # @opt = list.grep(Optional)
        # @rest = list.grep(Block).first
        # @post = list.grep(Post)
      end

      def inspect
        @list.map(&:inspect).join(', ')
      end

      def unwrap
        @list
      end

      def =~(other)
        if ::Parser::AST::Node === other && other.type == :args
          # method parameters validation
          args = other.to_a
          @list.length == args.length && @list.zip(args).all? { |sig, arg| sig =~ arg }
        elsif Array === other
          # send validation, a bit more complicated
          Helpers::ReducedArglist.new(@list, other).reducable?
        else
          raise 'bug'
        end
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
