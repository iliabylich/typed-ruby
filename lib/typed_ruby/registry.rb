module TypedRuby
  module Registry
    @modules = []
    @classes = []
    @constants = []
    @gvars = []
    @types = {}

    class << self
      attr_reader :modules, :classes, :constants, :gvars, :types

      def register_module(sig)
        @modules << sig
      end

      def register_class(sig)
        @classes << sig
      end

      def register_constant(sig)
        @constants << sig
      end

      def register_gvar(sig)
        @gvars << sig
      end

      def register_type(name:, type:)
        @types[name] = type
      end

      def find_module(module_name)
        @modules.detect { |sig| sig.name == module_name }
      end

      def find_class(class_name)
        @classes.detect { |sig| sig.name == class_name }
      end

      def find_type(name)
        @types[name]
      end

      def load_file(path)
        source = File.read(path)
        Parsers::SignaturesParser.new(source, path).import_into(self)
      end

      private

      def load_builtin
        root = File.expand_path('../../../types', __FILE__)

        load_file(File.join(root, 'corelib/boot.sig'))

        load_file(File.join(root, 'corelib/basic_object.sig'))
        load_file(File.join(root, 'corelib/module.sig'))
        load_file(File.join(root, 'corelib/class.sig'))

        load_file(File.join(root, 'corelib/kernel.sig'))

        load_file(File.join(root, 'corelib/string.sig'))
        load_file(File.join(root, 'corelib/integer.sig'))
      end
    end

    load_builtin
  end
end
