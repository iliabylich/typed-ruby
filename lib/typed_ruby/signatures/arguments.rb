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

      def unwrap
        @list.flat_map(&:unwrap)
      end

      class Any < self
        def inspect
          '...AnyArguments'
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

        def unwrap
          @type.find_method(@method_name).arguments
        end
      end

      ANY = Any.new
    end
  end
end
