module TypedRuby
  module Types
    class Reduced
      def =~(other)
        raise NotImplementedError, "no =~ in the #{self.class}"
      end

      def reduced?
        true
      end
    end
  end
end
