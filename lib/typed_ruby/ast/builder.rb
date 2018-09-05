module TypedRuby
  module AST
    class Builder
      def initialize(registry)
        @registry = registry
      end

      def instance_of(type)
        Types::InstanceOf.new(type)
      end

      def klass(name:, superclass: nil)
        Signatures::Class.new(name: name, superclass: superclass)
      end

      def module(name:)
        Signatures::Module.new(name: name)
      end

      def method(name:, arguments: [], returns:)
        arguments = [arguments] if arguments == any_args
        Signatures::Method.new(name: name, arguments: arguments, returns: returns)
      end

      def arg(name:, type:)
        Signatures::Arguments::Required.new(name: name, type: type)
      end

      def optarg(name:, type:)
        Signatures::Arguments::Optional.new(name: name, type: type)
      end

      def restarg(name:, type:)
        Signatures::Arguments::Restarg.new(name: name, type: type)
      end

      def any_args
        Signatures::Arguments::ANY
      end

      def any_type
        Types::ANY
      end

      def apply_module_items(items, on:)
        included_modules  = items.grep(ModuleInclude).map(&:mod)
        prepended_modules = items.grep(ModulePrepend).map(&:mod)
        methods           = items.grep(Signatures::Method)

        methods.each { |method| on.define_method(method) }
        included_modules.each { |mod| on.include(mod) }
        prepended_modules.each { |mod| on.prepend(mod) }
      end

      def find_or_create_class(name:, superclass: nil)
        klass = @registry.find_class(name)
        superclass = @registry.find_class(superclass)

        if klass.nil?
          klass = klass(name: name, superclass: superclass)
          @registry.register_class(klass)
        end

        klass
      end

      def find_or_create_module(name:)
        mod = @registry.find_module(name)

        if mod.nil?
          mod = self.module(name: name)
          @registry.register_module(mod)
        end

        mod
      end

      ModuleInclude = Struct.new(:mod)
      ModulePrepend = Struct.new(:mod)

      def module_include(mod)
        ModuleInclude.new(@registry.find_module(mod))
      end

      def module_prepend(mod)
        ModulePrepend.new(@registry.find_module(mod))
      end
    end
  end
end
