module TypedRuby
  module AST
    module Substitutions
      class Sends < Scoped
        def on_send(node)
          recv, mid, *args = *node

          recv = recv ? process(recv) : me
          args = process_all(args)

          can_reduce = reduced?(recv) && args.all? { |arg| reduced?(arg) }

          return replace(node, Types::ANY) unless can_reduce

          module_sig = recv.type
          method_sig = module_sig.find_method(mid.to_s)

          return replace(node, Types::ANY) unless method_sig

          if method_sig.arguments =~ args
            replace(node, method_sig.returns)
          end
        end
      end
    end
  end
end
