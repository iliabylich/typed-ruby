module TypedRuby
  module Signatures
    class Module
      attr_reader :name, :own_methods, :included_modules, :prepended_modules

      def initialize(name:)
        @name = name

        @included_modules = []
        @prepended_modules = []
        @own_methods = []
        @sclass_methods = []
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

      def define_singleton_method(sig)
        sclass.define_method(sig)
      end

      def inspect
        "ModuleType<#{name}>"
      end

      def >(other)
        self != other && other.ancestors.include?(self)
      end

      def <(other)
        self != other && ancestors.include?(other)
      end

      def >=(other)
        self == other || self > other
      end

      def <=(other)
        self == other || self < other
      end
    end
  end
end
