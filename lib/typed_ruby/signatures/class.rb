module TypedRuby
  module Signatures
    class Class < Module
      attr_reader :superclass

      def initialize(superclass:, **kwrest)
        @superclass = superclass
        super(kwrest)
      end

      def ancestors
        @ancestors ||= [
          *prepended_modules.flat_map(&:ancestors),
          self,
          *included_modules.flat_map(&:ancestors),
          *(superclass ? superclass.ancestors : [])
        ]
      end
    end
  end
end
