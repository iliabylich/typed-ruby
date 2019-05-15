module TypedRuby
  module Signatures
    class ReturnValue
      def initialize(type)
        @type = type
      end

      def unwrap
        @type
      end

      def inspect
        "ReturnValue<#{@type.inspect}>"
      end

      class Of < self
        def initialize(type, method_name)
          @type = type
          @method_name = method_name
        end

        def unwrap
          @type.find_method(@method_name).returns
        end

        def inspect
          "ReturnValueOf<#{@type.inspect}##{@method_name}>"
        end
      end
    end
  end
end
