module TypedRuby
  module Types
    class AnyStmt
      def inspect
        "ANY_STMT"
      end
    end

    ANY_STMT = AnyStmt.new.freeze
  end
end
