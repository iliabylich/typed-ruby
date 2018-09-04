module TypedRuby
  module AST
    module Substitutions
      class Sends < Scoped
        def initialize(*)
          super
          @lexical_scopes = []
        end

        def on_lvasgn(node)
          name, rhs = *node

          rhs = process(rhs)

          if reduced?(rhs)
            current_lexical_scope[name] = rhs
            ANY_STMT
          else
            node
          end
        end

        def in_lexical_scope
          @lexical_scopes << {}
          yield
        ensure
          @lexical_scopes.pop
        end

        def current_lexical_scope
          @lexical_scopes.last
        end

        def type_of(variable_name)
          current_lexical_scope[variable_name]
        end

        def on_begin(node)
          in_lexical_scope do
            children = node.children.map do |child|
              process(child)
            end

            node.updated(nil, children)
          end
        end

        def on_lvar(node)
          name, _ = *node

          if type = type_of(name)
            type
          else
            node
          end
        end

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
