module TypedRuby
  module Signatures
    class Arguments
      def initialize(list = [])
        @list = list
      end

      def inspect
        if @list.empty?
          "-no args-"
        else
          @list.map(&:inspect).join(', ')
        end
      end

      def unwrap
        @list
      end

      class Any < self
        def inspect
          '...AnyArguments'
        end
      end

      ANY = Any.new
    end
  end
end
