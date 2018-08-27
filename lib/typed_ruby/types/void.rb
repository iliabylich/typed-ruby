module TypedRuby
  module Types
    class Void
      def inspect
        "Void"
      end
    end

    VOID = Void.new.freeze
  end
end
