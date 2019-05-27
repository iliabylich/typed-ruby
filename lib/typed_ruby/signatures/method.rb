module TypedRuby
  module Signatures
    class Method
      attr_reader :name, :arguments, :returns, :mod

      def initialize(name:, arguments:, returns:)
        @name = name
        @arguments = arguments
        @returns = returns
        @mod = nil
      end

      def inspect
        "def #{@mod ? @mod.name : '<unbound>'} #{name}(#{arguments.inspect}): #{returns.inspect}"
      end

      def bind(mod)
        @mod = mod
      end

      def matches_definition?(def_node)
        if def_node.is_a?(::Parser::AST::Node) && def_node.type == :def
          mid, args_node, body_node = *def_node

          def_args = args_node.to_a
          sig_args = arguments

          sig_args.matches_ast?(def_args)
        else
          raise 'bug: wrong def_node type'
        end
      end

      def matches_send?(send_node)
        if send_node.is_a?(::Parser::AST::Node) && send_node.type == :send
          recv, mid, *args_node = *send_node

          send_args = args_node.to_a
          sig_args  = arguments

          sig_args.matches_send?(send_args)
        else
          raise 'bug: wrong send_node type'
        end
      end
    end

    class AnyMethod < Method
      attr_reader :name

      def initialize(name:)
        @name = name
      end

      def arguments
        Arguments::ANY
      end

      def returns
        Types::ANY
      end
    end
  end
end
