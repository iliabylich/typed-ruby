module TypedRuby
  module Signatures
    class Class
      attr_reader :name, :superclass, :methods, :included_modules, :prepended_modules

      def initialize(name:, superclass:, methods:, included_modules:, prepended_modules:)
        @name = name
        @superclass = superclass
        @methods = methods
        @included_modules = included_modules
        @prepended_modules = prepended_modules
      end

      def find_method(method_name)
        methods.detect { |method| method.name == method_name }
      end

      def inspect
        name
      end
    end
  end
end
