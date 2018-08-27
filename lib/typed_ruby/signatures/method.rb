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
  end
end
