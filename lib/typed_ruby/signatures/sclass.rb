module TypedRuby
  module Signatures
    class SClass < Class
      attr_reader :of

      def initialize(of:)
        @of = of
        super(
          name: nil,
          superclass: of.superclass ? of.superclass.sclass : nil,
          sclass_methods: [],
          own_methods: [],
          included_modules: [],
          prepended_modules: []
        )
      end

      def ancestors
        @ancestors ||= [
          *prepended_modules.flat_map(&:ancestors),
          self,
          *included_modules.flat_map(&:ancestors),
          *(superclass ? superclass.ancestors : [])
        ]
      end

      def inspect
        "SClass<#{of.name}>"
      end
    end
  end
end
