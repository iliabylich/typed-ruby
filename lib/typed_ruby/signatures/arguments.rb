module TypedRuby
  module Signatures
    class Arguments
      def initialize(list = [])
        @list = list
      end

      def inspect
        if @list.empty?
          "-no args-"
        else
          @list.map(&:inspect).join(', ')
        end
      end

      def matches_ast?(nodes)
        @list.length == nodes.length && @list.zip(nodes).all? { |sig, arg| sig.matches_ast?(arg) }
      end

      def matches_send?(nodes)
        r = nodes.length == @list.length && nodes.zip(@list).all? { |arg, sig| arg.can_be_assigned_to?(sig.type) }
        binding.pry unless r
        r
      end


      def each_arg
        @list.each { |arg| yield arg }
      end

      class Any < self
        def inspect
          '...AnyArguments'
        end

        def matches_ast?(*)
          true
        end

        def matches_send?(*)
          true
        end

        def each_arg(&block)
          # noop
        end
      end

      class Of < self
        def initialize(type, method_name)
          @type = type
          @method_name = method_name
        end

        def inspect
          "*ArgsOf<#{@type.inspect}##{@method_name}>"
        end

        def computed
          @type.find_method(@method_name).arguments
        end

        def matches_ast?(nodes)
          computed.matches_ast?(nodes)
        end

        def matches_send?(nodes)
          computed.matches_send?(nodes)
        end

        def each_arg
          computed.each_arg { |arg| yield arg }
        end
      end

      ANY = Any.new
    end
  end
end
