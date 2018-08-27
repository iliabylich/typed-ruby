module TypeHelper
  REGISTRY = TypedRuby::Registry.new

  def self.included(mod)
    mod.module_eval do
      let(:type_name) { RSpec.current_example.metadata[:type] }
      let(:method_name) { RSpec.current_example.metadata[:method] }

      let(:registry) { REGISTRY }
      subject(:signature) { REGISTRY.find_class(type_name).find_method(method_name) }
    end

    mod.define_singleton_method(:it_is_defined) do
      it 'is defined' do
        expect(signature).to_not eq(nil)
      end
    end

    mod.define_singleton_method(:it_takes) do |&blk|
      its(:arguments) { is_expected.to eq(instance_exec(&blk)) }
    end

    mod.define_singleton_method(:it_returns) do |&blk|
      its(:returns) { is_expected.to eq(instance_exec(&blk)) }
    end
  end

  def instance_of(type)
    TypedRuby::Types::InstanceOf.new(type)
  end

  def any
    TypedRuby::Types::ANY
  end
end
