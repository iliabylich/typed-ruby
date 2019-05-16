module TypedRuby
  module Types
    class Union < Reduced
      attr_reader :left, :right

      def initialize(left, right)
        @left = left
        @right = right
      end

      def inspect
        "#{[@left, @right].map(&:inspect).join(' | ')}"
      end

      def can_be_assigned_to?(other)
        left.can_be_assigned_to?(other) && right.can_be_assigned_to?(other)
      end

      def find_method(method_name)
        l = @left.find_method(method_name)
        r = @right.find_method(method_name)

        if l && r && l.arguments == r.arguments && l.returns == r.returns
          copy = l.dup
          copy.bind(nil)
          copy
        else
          nil
        end
      end
    end
  end
end
