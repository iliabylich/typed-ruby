module TypedRuby
  module AST
    module Scopes
      class ModuleNesting
        def initialize
          @stack = []
        end

        ClassEntry = Struct.new(:name)
        ModuleEntry = Struct.new(:name)
        MethodEntry = Struct.new(:name)

        def in_class(node)
          const, superclass, body = *node
          class_name = Helpers::ConstantName.new(const)

          with_entry ClassEntry.new(class_name) do
            yield
          end
        end

        def in_module(node)
          const, body = *node
          mod_name = Helpers::ConstantName.new(const)

          with_entry ModuleEntry.new(mod_name) do
            yield
          end
        end

        def in_def(node)
          mid, args, body = *node

          with_entry MethodEntry.new(mid) do
            yield
          end
        end

        def current_name
          name = @stack
                      .select { |item| item.is_a?(ClassEntry) || item.is_a?(ModuleEntry) }
                      .map(&:name)
                      .join('::')

          # global context
          if name == ''
            name = 'Object'
          end

          name
        end

        def in_class?
          @stack.last.is_a?(ClassEntry)
        end

        def in_module?
          @stack.last.is_a?(ModuleEntry)
        end

        def in_def?
          @stack.last.is_a?(MethodEntry)
        end

        private

        def with_entry(entry)
          @stack.push(entry)
          yield
        ensure
          @stack.pop
        end
      end
    end
  end
end
