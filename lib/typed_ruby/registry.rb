module TypedRuby
  class Registry
    def initialize
      @modules = []
      @constants = []
      @gvars = []

      load_builtin
    end

    def register_module(sig)
      @modules << sig
    end

    alias register_class register_module

    def register_constant(sig)
      @constants << sig
    end

    def register_gvar(sig)
      @gvars << sig
    end

    def find_module(module_name)
      @modules.detect { |mod| mod.name == module_name }
    end

    alias find_class find_module

    private

    def load_builtin
      root = File.expand_path('../../../types', __FILE__)

      load(File.join(root, 'corelib/basic_object.rb'))
      # load(File.join(root, 'corelib/object.rb'))
      # load(File.join(root, 'corelib/class.rb'))
      # load(File.join(root, 'corelib/module.rb'))

      load(File.join(root, 'corelib/kernel.rb'))
    end

    def load(path)
      instance_eval(File.read(path))
    end
  end
end
