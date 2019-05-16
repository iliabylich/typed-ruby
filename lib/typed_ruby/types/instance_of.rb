module TypedRuby
  module Types
    class InstanceOf < Reduced
      attr_reader :klass

      # @type TypeOf
      def initialize(klass)
        case klass
        when Signatures::Class
          @klass = klass
        else
          raise "argument must be a signature of a class/unions, got #{definition.inspect}"
        end
      end

      def ==(other)
        other.is_a?(InstanceOf) && klass == other.klass
      end

      def inspect
        "InstanceOf(#{klass.inspect})"
      end

      def can_be_assigned_to?(other)
        case other
        when InstanceOf
          klass.can_be_assigned_to?(other.klass)
        when Union
          can_be_assigned_to?(other.left) ||
          can_be_assigned_to?(other.right)
        else
          raise "argument must be InstanceOf or Union"
        end
      end

      def find_method(method_name)
        @klass.find_method(method_name)
      end
    end
  end
end
