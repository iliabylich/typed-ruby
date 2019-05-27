module TypedRuby
  module Types
    class Intersection < Type
      attr_reader :left, :right

      def initialize(left, right)
        case left
        when ::TypedRuby::Type
          @left = left
        else
          raise "`left` argument must be Type, got #{left.inspect}"
        end

        case right
        when ::TypedRuby::Type
          @right = right
        else
          raise "`right` argument must be Type, got #{right.inspect}"
        end
      end

      def inspect
        "#{left.inspect} | #{right.inspect}"
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
