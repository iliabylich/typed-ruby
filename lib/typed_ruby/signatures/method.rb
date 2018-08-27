module TypedRuby
  module Signatures
    class Method
      attr_reader :name, :arguments, :returns

      def initialize(name:, arguments:, returns:)
        @name = name
        @arguments = arguments
        @returns = returns
        @mod = nil
      end

      def inspect
        "def #{@mod.name} #{name}(#{arguments.map(&:inspect).join(', ')}): #{returns.inspect}"
      end

      def bind(mod)
        @mod = mod
      end
    end

    class AnyMethod < Method
      attr_reader :name

      def initialize(name:)
        @name = name
      end

      class AnyArgs
        def inspect
          '...AnyArguments'
        end
      end

      ANY_ARGS = AnyArgs.new.freeze

      def arguments
        [ANY_ARGS]
      end

      def returns
        Types::ANY
      end
    end
  end
end
