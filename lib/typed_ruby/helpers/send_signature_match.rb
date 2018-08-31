module TypedRuby
  module Helpers
    class SendSignatureMatch
      def initialize(method_signature, send_signature)
        @expected = method_signature.arguments.map(&:type)
        @actual = send_signature
      end

      def call
        @expected == @actual
      end
    end
  end
end
