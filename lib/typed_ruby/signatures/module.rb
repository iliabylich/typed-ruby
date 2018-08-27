module TypedRuby
  module Signatures
    class Module
      attr_reader :name, :own_methods, :included_modules, :prepended_modules

      def initialize(name:, own_methods:, sclass_methods:, included_modules:, prepended_modules:)
        @name = name
        @included_modules = included_modules
        @prepended_modules = prepended_modules

        @own_methods = []
        own_methods.each { |sig| define_method(sig) }

        sclass_methods.each { |sig| sclass.define_method(sig) }
      end

      def find_method(method_name)
        ancestors.each do |mod|
          mod.own_methods.each do |method|
            return method if method.name == method_name
          end
        end

        nil
      end

      def sclass
        @sclass ||= Signatures::SClass.new(of: self)
      end

      def ancestors
        @ancestors ||= [
          *prepended_modules.flat_map(&:ancestors),
          self,
          *included_modules.flat_map(&:ancestors)
        ]
      end

      def include(mod)
        @included_modules << mod
        @ancestors = nil
      end

      def prepend(mod)
        @prepended_modules << mod
        @ancestors = nil
      end

      def define_method(sig)
        sig.bind(self)
        @own_methods << sig
      end

      def inspect
        "ModuleType<#{name}>"
      end
    end
  end
end
