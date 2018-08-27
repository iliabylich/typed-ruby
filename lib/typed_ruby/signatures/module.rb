module TypedRuby
  module Signatures
    class Module
      attr_reader :name, :methods, :included_modules, :prepended_modules

      def initialize(name:, methods:, included_modules:, prepended_modules:)
        @name = name
        @methods = methods
        @included_modules = included_modules
        @prepended_modules = prepended_modules
      end

      def find_method(method_name)
        methods.detect { |method| method.name == method_name }
      end
    end
  end
end
