module TypedRuby
  module AST
    module Substitutions
      class Scoped < Base
        def initialize(*)
          super
          @scope_names = []
          @scope_types = []
        end

        def current_scope_name
          @scope_names.join('::')
        end

        def current_scope_type
          @scope_types.last
        end

        def current_module_signature
          case current_scope_type
          when :class
            @registry.find_class(current_scope_name)
          when :module
            @registry.find_module(current_scope_name)
          else
            raise "Unsupported scope type #{current_scope_type.inspect}"
          end
        end

        def me
          current_module_signature && Types::InstanceOf.new(current_module_signature)
        end

        def in_signature_scope(type:, name:)
          @scope_types << type
          @scope_names << name
          yield
        ensure
          @scope_types.pop
          @scope_names.pop
        end

        def on_class(node)
          const, superclass, body = *node

          in_signature_scope(type: :class, name: Helpers::ConstantName.new(const)) do
            super(node)
          end
        end

        def on_module(node)
          const, body = *node

          in_signature_scope(type: :module, name: Helpers::ConstantName.new(const)) do
            super(node)
          end
        end
      end
    end
  end
end
