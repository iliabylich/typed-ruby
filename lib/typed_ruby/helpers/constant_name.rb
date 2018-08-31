module TypedRuby
  module Helpers
    class ConstantName < String
      def initialize(node)
        super(name_of(node))
      end

      private

      def name_of(node)
        scope, name = *node
        if scope
          name_of(scope) + '::' + name.to_s
        else
          name.to_s
        end
      end
    end
  end
end
