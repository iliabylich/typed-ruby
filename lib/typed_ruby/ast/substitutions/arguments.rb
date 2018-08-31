module TypedRuby
  module AST
    module Substitutions
      class Arguments < Base
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

        def in_scope(type:, name:)
          @scope_types << type
          @scope_names << name
          yield
        ensure
          @scope_types.pop
          @scope_names.pop
        end

        def on_class(node)
          const, superclass, body = *node

          in_scope(type: :class, name: Helpers::ConstantName.new(const)) do
            super(node)
          end
        end

        def on_module(node)
          const, body = *node

          in_scope(type: :module, name: Helpers::ConstantName.new(const)) do
            super(node)
          end
        end

        def on_def(node)
          mid, args, body = *node
          method_signature = current_module_signature.find_method(mid.to_s)

          matches = Helpers::MethodSignatureMatch.new(method_signature, args).call

          unless matches
            raise "#{args.loc.expression.to_s}: signature #{method_signature.inspect} doesn't match #{args.loc.expression.source}"
          end

          method_signature.arguments.each do |arg|
            body = Substitutions::Explicit.new(
              from: s(:lvar, arg.name.to_sym),
              to:   arg.type
            ).call(body)
          end

          node.updated(nil, [mid, args, body])
        end
      end
    end
  end
end
