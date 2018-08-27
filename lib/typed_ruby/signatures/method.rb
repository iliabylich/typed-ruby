module TypedRuby
  module Signatures
    class Method
      attr_reader :name, :arguments, :returns

      def initialize(name:, arguments:, returns:)
        @name = name
        @arguments = arguments
        @returns = returns
      end
    end

    class AnyMethod
      attr_reader :name

      def initialize(name:)
        @name = name
      end

      def arguments
        '<Any Arguments>'
      end

      def returns
        Types::ANY
      end
    end
  end
end
