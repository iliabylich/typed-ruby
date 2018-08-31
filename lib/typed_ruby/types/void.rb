module TypedRuby
  module Types
    class Void < Reduced
      def inspect
        "Void"
      end
    end

    VOID = Void.new.freeze
  end
end
