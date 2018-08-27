module TypedRuby
  module Types
    class Any
      def inspect
        "Any"
      end
    end

    ANY = Any.new.freeze
  end
end
