module TypedRuby
  module Types
    class InstanceOf < Reduced
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def ==(other)
        other.is_a?(InstanceOf) && name == other.name
      end

      def inspect
        "InstanceOf(#{name})"
      end
    end
  end
end
