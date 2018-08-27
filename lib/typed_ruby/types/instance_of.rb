module TypedRuby
  module Types
    class InstanceOf
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def ==(other)
        other.is_a?(InstanceOf) && name == other.name
      end
    end
  end
end
