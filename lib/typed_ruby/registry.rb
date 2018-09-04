module TypedRuby
  class Registry
    attr_reader :modules, :classes, :constants, :gvars

    def initialize
      @modules = []
      @classes = []
      @constants = []
      @gvars = []

      load_builtin
    end

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

    def find_module(module_name)
      @modules.detect { |sig| sig.name == module_name } ||
        raise("Module #{module_name} is not registered")
    end

    def find_class(class_name)
      @classes.detect { |sig| sig.name == class_name } ||
        raise("Class #{class_name} is not registered")
    end

    def load_file(path)
      instance_eval(File.read(path), path)
    end

    private

    def load_builtin
      root = File.expand_path('../../../types', __FILE__)

      load_file(File.join(root, 'corelib/boot.rb'))

      load_file(File.join(root, 'corelib/basic_object.rb'))
      load_file(File.join(root, 'corelib/module.rb'))
      load_file(File.join(root, 'corelib/class.rb'))

      load_file(File.join(root, 'corelib/kernel.rb'))

      load_file(File.join(root, 'corelib/string.rb'))
      load_file(File.join(root, 'corelib/integer.rb'))
    end
  end
end
