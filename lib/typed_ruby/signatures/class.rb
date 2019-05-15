module TypedRuby
  module Signatures
    class Class < Module
      attr_reader :superclass

      def initialize(superclass:, **kwrest)
        @superclass = superclass
        super(kwrest)

        define_default_allocator
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
        "ClassType<#{name}>"
      end

      private

      def define_default_allocator
        sclass.define_method(
          Method.new(
            name: 'allocate',
            arguments: Arguments.new([]),
            returns: ReturnValue.new(Types::InstanceOf.new(self))
          )
        )

        sclass.define_method(
          Method.new(
            name: 'new',
            arguments: Arguments::Of.new(self, 'initialize'),
            returns: ReturnValue::Of.new(sclass, 'allocate')
          )
        )
      end
    end
  end
end
