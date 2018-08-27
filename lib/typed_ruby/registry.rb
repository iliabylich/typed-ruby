module TypedRuby
  class Registry
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

    private

    def load_builtin
      root = File.expand_path('../../../types', __FILE__)

      load(File.join(root, 'corelib/basic_object.rb'))
      load(File.join(root, 'corelib/object.rb'))
      load(File.join(root, 'corelib/module.rb'))
      # load(File.join(root, 'corelib/class.rb'))

      load(File.join(root, 'corelib/kernel.rb'))
    end

    def load(path)
      instance_eval(File.read(path))
    end
  end
end
