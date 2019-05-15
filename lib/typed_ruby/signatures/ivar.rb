module TypedRuby
  module Signatures
    class Ivar
      attr_reader :name, :type

      def initialize(name:, type:)
        @name = name
        @type = type
      end

      def inspect
        "@#{@name} : #{@type.inspect}"
      end
    end
  end
end
