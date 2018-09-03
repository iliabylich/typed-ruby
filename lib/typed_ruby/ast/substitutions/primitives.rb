module TypedRuby
  module AST
    module Substitutions
      class Primitives < Base
        def on_int(node)
          replace(node, instance_of(find_class('Integer')))
        end

        def on_str(node)
          replace(node, instance_of(find_class('String')))
        end
      end
    end
  end
end
