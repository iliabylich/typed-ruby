module TypedRuby
  module Types
    class Reduced
      def =~(other)
        raise NotImplementedError, "no =~ in the #{self.class}"
      end
    end
  end
end
