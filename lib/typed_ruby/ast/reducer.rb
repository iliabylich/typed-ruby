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

      def result
        process(@ast)
      end

      (instance_methods.grep(/\Aon_/) - [:on_argument, :on_vasgn]).each do |mid|
        define_method(mid) do |*|
          raise NotImplementedError, mid.to_s
        end
      end

      def on_begin(node)
        node = super
        stmts = *node

        unreducable = stmts.grep(Parser::AST::Node)
        if unreducable.empty?
          replace(node, Types::ANY_STMT)
        else
          report(unreducable)
        end
      end

      def on_const(node)
        scope, name = *super

        if class_sig = find_type(name.to_s)
          type = instance_of(class_sig.sclass)
          replace(node, type)
        else
          # maybe a constant
          raise NotImplementedError
        end
      end

      def on_class(node)
        @module_nesting.in_class(node) do
          const, superclass, body = *node
          body = process(body)
          if body == Types::ANY_STMT
            Types::ANY_STMT
          else
            raise "Unreducable: #{body}"
          end
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
          raise "#{node} doesn't match defined signature #{method_sig.inspect}"
        end

        @module_nesting.in_def(node) do
          @locals.open do
            @locals.enter_method(method_sig)

            reduced = super
            _, _, body = *reduced

            if body.nil? || body == Types::ANY_STMT || body.is_a?(Types::InstanceOf)
              replace(reduced, Types::ANY_STMT)
            end
          end
        end
      end

      def on_args(node); super; end
      def on_arg(node); super; end

      def on_int(node)
        replace(node, instance_of(find_type('Integer')))
      end

      def on_str(node)
        replace(node, instance_of(find_type('String')))
      end

      def on_true(node)
        replace(node, instance_of(find_type('Boolean')))
      end

      def on_false(node)
        replace(node, instance_of(find_type('Boolean')))
      end

      def on_send(node)
        node = super
        # TODO: add validation
        recv, mid, *args = *node

        if recv.nil?
          recv = instance_of(current_module)
        end

        method_sig = recv.find_method(mid.to_s)

        if method_sig.nil?
          raise "Unknown method #{recv.inspect}##{mid}"
        end

        if method_sig.matches_send?(node)
          replace(node, method_sig.returns.type)
        else
          raise "#{node} doesn't match defined signature #{method_sig.inspect}"
        end
      end

      def on_lvasgn(node)
        name, value = *super

        @locals.declare_lvar(name, value)

        replace(node, Types::ANY_STMT)
      end

      def on_lvar(node)
        name, _ = *node
        type = @locals.find(name)
        replace(node, type)
      end

      def on_ivasgn(node)
        name, value_type = *super

        ivar_def = current_module.find_ivar(name[1..-1])
        acceptable_type = ivar_def.type

        if value_type.can_be_assigned_to?(acceptable_type)
          replace(node, Types::ANY_STMT)
        else
          raise "#{value_type.inspect} can't be assigned to #{ivar_def.inspect}"
        end
      end

      def on_ivar(node)
        name, = *node
        ivar_def = current_module.find_ivar(name[1..-1])
        type = ivar_def.type
        replace(node, type)
      end

      private

      def replace(from, to)
        called_from = caller_locations(1,1)[0]
        puts "Substitution (#{called_from.label}:#{called_from.lineno}) (#{self.class.name}): #{from} -> #{to.inspect}"
        to
      end

      def s(type, *children)
        ::Parser::AST::Node.new(type, children)
      end

      def instance_of(type)
        Types::InstanceOf.new(type)
      end

      def find_type(name)
        @registry.find_type(name)
      end

      def process(node)
        return if node.nil?
        return node unless ::Parser::AST::Node === node

        on_handler = :"on_#{node.type}"
        if respond_to? on_handler
          new_node = send on_handler, node
        else
          raise NotImplementedError, on_handler
        end

        node = new_node if new_node

        node
      end

      def current_module
        @registry.find_type(@module_nesting.current_name)
      end

      def report(nodes)
        puts "The following nodes can't be reduced:"
        nodes.each { |node| puts node }
      end
    end
  end
end
