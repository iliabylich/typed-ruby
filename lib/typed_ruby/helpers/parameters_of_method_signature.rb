module TypedRuby
  module Helpers
    class ParametersOfMethodSignature < Array
      def initialize(args)
        args.each do |arg|
          case arg
          when Signatures::Arguments::Required
            push [:req, arg.name]
          else
            raise NotImplementedError, "Unsupported argument #{arg.class}"
          end
        end
      end
    end
  end
end
