module TypedRuby
  module Signatures
    class ReturnValue < ::TypedRuby::Type
      attr_reader :type

      def initialize(type)
        @type = type
      end

      def inspect
        "ReturnValue<#{@type.inspect}>"
      end

      def find_method(method_name)
        @type.find_method(method_name)
      end

      class Of < self
        def initialize(type_of, method_name_of)
          @type_of = type_of
          @method_name_of = method_name_of
        end

        def type
          @type_of.find_method(@method_name_of).returns
        end

        def find_method(method_name)
          type.find_method(method_name)
        end

        def inspect
          "ReturnValueOf<#{@type_of.inspect}##{@method_name_of}>"
        end
      end
    end
  end
end
