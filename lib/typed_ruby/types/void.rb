module TypedRuby
  module Types
    class Void < ::TypedRuby::Type
      def initialize
      end

      def inspect
        "Void"
      end
    end

    VOID = Void.new.freeze
  end
end
