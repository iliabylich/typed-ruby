module TypedRuby
  module Types
    class InstanceOf < Reduced
      attr_reader :type

      def initialize(type)
        unless type.is_a?(Signatures::Module)
          raise "type must be a signature of a class/module, got #{type.inspect}"
        end

        @type = type
      end

      def ==(other)
        InstanceOf === other && type == other.type
      end

      def inspect
        "InstanceOf(#{type.name})"
      end

      def >=(other)
        self.type >= other.type
      end

      def >(other)
        self.type > other.type
      end

      def <=(other)
        self.type <= other.type
      end

      def <(other)
        self.type < other.type
      end
    end
  end
end
