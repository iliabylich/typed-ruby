module TypedRuby
  module Types
    class InstanceOf < Reduced
      attr_reader :type

      def initialize(type)
        raise 'type must must be a signature of a class/module' unless Signatures::Module === type
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
