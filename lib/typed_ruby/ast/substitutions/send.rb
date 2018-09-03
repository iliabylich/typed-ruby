module TypedRuby
  module AST
    module Substitutions
      class Send < Base
        def on_send(node)
          recv, mid, *args = *node

          recv = process(recv)
          args = process_all(args)

          can_reduce = reduced?(recv) && args.all? { |arg| reduced?(arg) }

          class_sig = @registry.find_class(recv.name)
          method_sig = class_sig.find_method(mid.to_s)

          matches = Helpers::SendSignatureMatch.new(method_sig, args).call

          if matches
            replace(node, method_sig.returns)
          end
        end

        def reduced?(node)
          node.is_a?(Types::Reduced)
        end
      end
    end
  end
end
