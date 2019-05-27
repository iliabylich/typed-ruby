module TypedRuby
  module Types
    class InstanceOf
      attr_reader :type

      def initialize(type)
        case type
        when ::TypedRuby::Type
          @type = type
        else
          raise "argument must be Type, got #{type.inspect}"
        end
      end

      def ==(other)
        other.is_a?(InstanceOf) && type == other.type
      end

      def inspect
        "InstanceOf(#{type.inspect})"
      end

      def can_be_assigned_to?(other)
        case other
        when InstanceOf
          type.can_be_assigned_to?(other.type)
        when Intersection
          can_be_assigned_to?(other.left) ||
          can_be_assigned_to?(other.right)
        else
          raise "argument must be InstanceOf or Union"
        end
      end

      def find_method(method_name)
        @type.find_method(method_name)
      end
    end
  end
end
