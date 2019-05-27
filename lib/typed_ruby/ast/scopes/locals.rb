module TypedRuby
  module AST
    module Scopes
      class Locals
        def initialize
          @stack = []
          @stack << {} # global lvars scope
        end

        def open
          @stack << {}
          yield
        ensure
          @stack.pop
        end

        def declare_lvar(name, type)
          name = name.to_s

          if current_env.has_key?(name)
            raise "Redeclaring a local variable #{name}"
          end

          @stack.last[name] = type
        end

        def enter_method(method_sig)
          method_sig.arguments.each_arg do |arg_sig|
            declare_lvar(arg_sig.name, arg_sig.type)
          end
        end

        def find(name)
          current_env[name.to_s]
        end

        private

        def current_env
          @stack.last
        end
      end
    end
  end
end
