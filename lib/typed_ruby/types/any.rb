module TypedRuby
  module Types
    class Any < Reduced
      def inspect
        "Any"
      end
    end

    ANY = Any.new.freeze
  end
end
