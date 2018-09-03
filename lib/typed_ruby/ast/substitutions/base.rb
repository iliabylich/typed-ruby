module TypedRuby
  module AST
    module Substitutions
      class Base < ::Parser::AST::Processor
        def initialize(registry:, ast:)
          @registry = registry
          @ast = ast
        end

        def call
          process(@ast)
        end

        def s(type, *children)
          ::Parser::AST::Node.new(type, children)
        end

        def instance_of(type)
          Types::InstanceOf.new(type)
        end

        def find_class(name)
          @registry.find_class(name)
        end

        def replace(from, to)
          puts "Substitution: #{from} -> #{to.inspect}"
          to
        end

        def process(node)
          return if node.nil?
          return node unless ::Parser::AST::Node === node

          on_handler = :"on_#{node.type}"
          if respond_to? on_handler
            new_node = send on_handler, node
          else
            new_node = handler_missing(node)
          end

          node = new_node if new_node

          node
        end

        def reduced?(node)
          Types::Reduced === node
        end
      end
    end
  end
end
