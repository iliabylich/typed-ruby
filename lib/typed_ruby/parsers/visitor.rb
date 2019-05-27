module TypedRuby
  module AST
    class Visitor
      def initialize(ast)
        @ast = ast
      end

      def apply_on(registry)
        @registry = registry
        process(@ast)
      ensure
        @registry = nil
      end

      def process(node)
        type, *children = node
        send(:"on_#{type}", *children)
      end

      private

      def process_all(nodes)
        nodes.map { |node| process(node) }
      end

      def find_type(name, raise_if_missing:)
        result = @registry.find_type(name)
        if result.nil? && raise_if_missing
          raise "Can't find type #{name}"
        else
          result
        end
      end

      def find_class(name, raise_if_missing:)
        result = find_type(name, raise_if_missing: raise_if_missing)
        case result
        when Signatures::Class
          result
        else
          raise "Type #{name} exists, but it's a #{result.class}, not a #{Signatures::Class}"
        end
      end

      def find_module(name, raise_if_missing:)
        result = find_type(name, raise_if_missing: raise_if_missing)
        case result
        when Signatures::Module
          result
        else
          raise "Type #{name} exists, but it's a #{result.class}, not a #{Signatures::Module}"
        end
      end

      def on_program(stmts)
        process_all(stmts)
      end

      def on_class(class_to_define, superclass, stmts)
        class_name = process(class_to_define)
        klass = find_type(class_name, raise_if_missing: false)

        superclass = process(superclass) if superclass
        if superclass.nil?
          if class_name != 'BasicObject'
            superclass = find_class('Object', raise_if_missing: true)
          end
        else
          superclass = find_class(superclass, raise_if_missing: true)
        end

        case klass
        when nil
          klass = Signatures::Class.new(
            name: class_name,
            superclass: superclass
          )
          @registry.register_type(class_name, klass)
        when Signatures::Class
          # reopen
        else
          raise "Type #{name} exists, but it's a #{klass.class}, not a #{Signatures::Class}"
        end

        with_definee(klass) { process_all(stmts) }
      end

      def on_module(module_to_define, stmts)
        module_name = process(module_to_define)

        mod = Signatures::Module.new(
          name: module_name
        )

        @registry.register_type(module_name, mod)

        with_definee(mod) { process_all(stmts) }
      end

      def on_include(module_name)
        mod = find_module(module_name, raise_if_missing: true)
        @current_definee.include(mod)
      end

      def on_prepend(module_name)
        mod = find_module(module_name, raise_if_missing: true)
        @current_definee.prepend(mod)
      end

      def with_definee(definee)
        @current_definee, previous_definee = definee, @current_definee
        yield
      ensure
        @current_definee = previous_definee
      end

      def on_type(name)
        name
      end

      def on_eval(code)
        @registry.instance_eval(code, '__RUBY__')
      end

      def on_method(on_self:, name:, arglist:, returns:)
        if on_self
          puts "def self.something is unsupported for now; ignoring"
        end

        arglist = process(arglist)
        returns = process(returns)

        @current_definee.define_method(
          Signatures::Method.new(
            name: name,
            arguments: arglist,
            returns: returns
          )
        )
      end

      def on_arglist(args)
        case args
        when :any_args
          Signatures::Arguments::ANY
        when Array
          Signatures::Arguments.new(process_all(args))
        else
          binding.pry
          raise 'bug: unreachable'
        end
      end

      def on_generic(name:, variables:)
        binding.pry
        raise 'dead'
      end

      def on_returns(type)
        Signatures::ReturnValue.new(
          instance_of(
            find_type(
              process(type),
              raise_if_missing: true
            )
          )
        )
      end

      def on_void
        'void'
      end

      def on_arg(type:, kind:, name:)
        type = find_type(process(type), raise_if_missing: true)
        send("on_#{kind}arg", type: instance_of(type), name: name)
      end

      def on_reqarg(type:, name:)
        Signatures::Arguments::Required.new(name: name, type: type)
      end

      def on_optarg(type:, name:)
        Signatures::Arguments::Optional.new(name: name, type: type)
      end

      def on_restarg(type:, name:)
        Signatures::Arguments::Restarg.new(name: name, type: type)
      end

      def on_kwreqarg(type:, name:)
        Signatures::Arguments::Keyword.new(name: name, type: type)
      end

      def on_kwoptarg(type:, name:)
        Signatures::Arguments::KeywordOptional.new(name: name, type: type)
      end

      def on_kwrestarg(type:, name:)
        Signatures::Arguments::KeywordRest.new(name: name, type: type)
      end

      def on_blockarg(type:, name:)
        Signatures::Arguments::Block.new(name: name, type: type)
      end

      def on_ivar(name, type)
        type = find_type(process(type), raise_if_missing: true)

        @current_definee.define_ivar(
          Signatures::Ivar.new(
            name: name,
            type: instance_of(type)
          )
        )
      end

      def instance_of(type)
        Types::InstanceOf.new(type)
      end
    end
  end
end
