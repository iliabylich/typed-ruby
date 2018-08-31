module TypedRuby
  module AST
    module Substitutions
      class Arguments < Scoped
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
