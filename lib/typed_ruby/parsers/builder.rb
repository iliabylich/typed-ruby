module TypedRuby
  module AST
    class Builder
      def initialize(registry)
        @registry = registry
      end

      def instance_of(name_t:)
        Types::InstanceOf.new(find_class(name_t: name_t))
      end

      def method_def(name_t:, arguments: [], returns:)
        arguments = [arguments] if arguments == any_args
        Signatures::Method.new(name: value_of(name_t), arguments: arguments, returns: returns)
      end

      def arg(name_t:, type:)
        Signatures::Arguments::Required.new(name: value_of(name_t), type: type)
      end

      def optarg(name_t:, type:)
        Signatures::Arguments::Optional.new(name: value_of(name_t), type: type)
      end

      def restarg(name_t:, type:)
        Signatures::Arguments::Restarg.new(name: value_of(name_t), type: type)
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

      def find_or_create_class(name_t:, superclass_t: [])
        klass = find_class(name_t: name_t)

        if klass.nil?
          klass = klass(name_t: name_t, superclass_t: superclass_t)
          @registry.register_class(klass)
        end

        klass
      end

      def find_or_create_module(name_t:)
        mod = find_module(name_t: name_t)

        if mod.nil?
          mod = self.module(name_t: name_t)
          @registry.register_module(mod)
        end

        mod
      end

      ModuleInclude = Struct.new(:mod)
      ModulePrepend = Struct.new(:mod)

      def module_include(name_t:)
        ModuleInclude.new(find_module(name_t: name_t))
      end

      def module_prepend(name_t:)
        ModulePrepend.new(find_module(name_t: name_t))
      end

      protected

      def value_of(tok)
        tok[0]
      end

      def pos_of(tok)
        tok[1]
      end

      def find_class(name_t:)
        @registry.find_class(value_of(name_t))
      end

      def find_module(name_t:)
        @registry.find_module(value_of(name_t))
      end

      def klass(name_t:, superclass_t: [])
        name = value_of(name_t)
        superclass = find_class(name_t: superclass_t)

        if superclass.nil? && name != 'BasicObject'
          superclass = @registry.find_class('Object')
        end

        Signatures::Class.new(
          name: name,
          superclass: superclass
        )
      end

      def module(name_t:)
        Signatures::Module.new(name: value_of(name_t))
      end
    end
  end
end
