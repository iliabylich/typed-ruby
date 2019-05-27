module TypedRuby
  module Types
    class Any < ::TypedRuby::Type
      def initialize; end

      def inspect
        "Any"
      end

      def name
        "Any"
      end
    end

    ANY = Any.new.freeze
  end
end
