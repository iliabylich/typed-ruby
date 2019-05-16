module TypedRuby
  module Signatures
    class Class < Module
      attr_reader :superclass, :ivars

      def initialize(superclass:, **kwrest)
        @superclass = superclass
        @ivars = []

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

      def define_ivar(ivar_sig)
        @ivars << ivar_sig
      end

      def find_ivar(ivar_name)
        @ivars.detect { |ivar| ivar.name == ivar_name.to_s }
      end

      def inspect
        "class<#{name}>"
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
