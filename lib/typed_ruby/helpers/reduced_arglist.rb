module TypedRuby
  module Helpers
    class ReducedArglist
      def initialize(sig, arglist)
        @sig = sig
        @arglist = arglist
      end

      def reducable?
        @sig.grep(Signatures::Arguments::Required).each do |req|
          unless req =~ @arglist.pop
            return false
          end
        end

        true
      end
    end
  end
end
