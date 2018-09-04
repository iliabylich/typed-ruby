module TypedRuby
  module Signatures
    class Method
      attr_reader :name, :arguments, :returns, :mod

      def initialize(name:, arguments:, returns:)
        @name = name
        @arguments = Arguments.new(arguments)
        @returns = returns
        @mod = nil
      end

      def inspect
        "def #{@mod.name} #{name}(#{arguments.inspect}): #{returns.inspect}"
      end

      def bind(mod)
        @mod = mod
      end

      def matches?(ast)
        @arguments.matches?(ast)
      end

      def can_receive?(ast)
        @arguments.can_receive?(ast)
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
