module TypedRuby
  module AST
    module Substitutions
      class Primitives < Base
        def on_int(node)
          replace(node, instance_of('Integer'))
        end

        def on_str(node)
          replace(node, instance_of('String'))
        end
      end
    end
  end
end
