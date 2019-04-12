module TypedRuby
  module Types
    class AnyStmt < Reduced
      def inspect
        "ANY_STMT"
      end
    end

    ANY_STMT = AnyStmt.new.freeze
  end
end
