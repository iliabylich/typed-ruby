module TypedRuby
  module Helpers
    class MethodSignatureMatch
      def initialize(method_signature, actual_args)
        @method_signature = method_signature
        @actual_args = actual_args
      end

      def call
        expected_args == actual_args
      end

      private

      def expected_args
        @method_signature.arguments.map do |arg|
          case arg
          when Signatures::Arguments::Required
            [:req, arg.name]
          else
            raise "Can't validate argument #{arg.class}"
          end
        end
      end

      def actual_args
        @actual_args.to_a.map do |arg|
          name, _ = *arg
          case arg.type
          when :arg
            [:req, name.to_s]
          else
            raise "Can't validate argument #{arg}"
          end
        end
      end
    end
  end
end
