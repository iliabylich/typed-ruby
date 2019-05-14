require 'parser/ast/processor'

require 'typed_ruby/ast/scopes/module_nesting'
require 'typed_ruby/ast/scopes/locals'

module TypedRuby
  module AST
    class Reducer < ::Parser::AST::Processor
      def initialize(ast:, registry:)
        @ast      = ast
        @registry = registry

        @module_nesting = Scopes::ModuleNesting.new
        @locals         = Scopes::Locals.new
      end

      SUBSTITUTIONS = [
        # Substitutions::Primitives,
        # Substitutions::Constants,
        # Substitutions::LocalVariables,
        # Substitutions::InstanceVariables,
        # Substitutions::Sends,
      ]

      def result
        process(@ast)
      end

      (instance_methods.grep(/on_/) - [:on_argument]).each do |mid|
        define_method(mid) do |*|
          raise NotImplementedError, mid.to_s
        end
      end

      def on_begin(node)
        reduced = super
        reduced_stmts = *reduced

        if reduced_stmts.all?(&:reduced?)
          replace(reduced, Types::ANY_STMT)
        else
          unreducables = reduced_stmts.reject(&:reduced?)
          # Types::Unreducable.new(node, )
        end
      end

      def on_const(node)
        scope, name = *super

        if class_sig = find_class(name.to_s)
          type = instance_of(class_sig.sclass)
          replace(node, type)
        else
          # maybe a constant
          raise NotImplementedError
        end
      end

      def on_class(node)
        @module_nesting.in_class(node) do
          super
        end
      end

      def on_module(node)
        @module_nesting.in_module(node) do
          super
        end
      end

      def on_def(node)
        mid, args, body = *node
        method_sig = current_module.find_method(mid.to_s)

        if method_sig.nil?
          raise "Unknown method #{@module_nesting.current_name}##{mid}"
        end

        unless method_sig.matches_definition?(node)
          raise "#{node} doesn't match defined signature #{method_sig}"
        end

        @module_nesting.in_def(node) do
          @locals.open do
            @locals.enter_method(method_sig)

            reduced = super
            _, _, body = *reduced

            if body.reduced?
              replace(reduced, Types::ANY_STMT)
            end
          end
        end
      end

      def on_args(node); super; end
      def on_arg(node); super; end

      def on_int(node)
        replace(node, instance_of(find_class('Integer')))
      end

      def on_send(node)
        node = super
        # TODO: add validation
        recv, mid, *args = *node

        if recv.nil?
          recv = instance_of(current_module)
        end

        method_sig = recv.type.find_method(mid.to_s)

        if method_sig.nil?
          raise "Unknown method #{recv.type.inspect}##{mid}"
        end

        if method_sig.matches_send?(node)
          replace(node, method_sig.returns)
        else
          raise "#{node} doesn't match defined signature #{method_sig}"
        end
      end

      def on_lvar(node)
        name, _ = *node
        type = @locals.find(name)
        replace(node, type)
      end

      private

      def replace(from, to)
        puts "Substitution (#{self.class.name}): #{from} -> #{to.inspect}"
        to
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

      def current_module
        @registry.find_class(@module_nesting.current_name)
      end
    end
  end
end
