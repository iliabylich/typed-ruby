module TypedRuby
  module Types
    class Unreducable
      def initialize(node, error: nil)
        @node = node
        @error = error
      end

      def reduced?
        false
      end
    end
  end
end
