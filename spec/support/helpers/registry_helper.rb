module RegistryHelper
  REGISTRY = TypedRuby::Registry

  def find_class(class_name)
    REGISTRY.find_class(class_name)
  end

  def find_module(module_name)
    REGISTRY.find_module(module_name)
  end

  def find_method(method_name)
    signature.find_method(method_name)
  end

  def instance_of(type)
    TypedRuby::Types::InstanceOf.new(type)
  end

  def any
    TypedRuby::Types::ANY
  end

  extend RSpec::Matchers::DSL

  matcher :be_defined do
    match do |method_signature|
      method_signature != nil
    end
  end

  matcher :take_arguments do |expected_arguments|
    match do |method_signature|
      unwrapped = method_signature.arguments.unwrap.map(&:type)
      unwrapped == expected_arguments
    end
  end

  matcher :return_type do |expected_return_type|
    match do |method_signature|
      method_signature.returns == expected_return_type
    end
  end

  matcher :be_any_method do
    match do |method_signature|
      TypedRuby::Signatures::AnyMethod === method_signature
    end
  end

  matcher :have_included do |expected_module|
    match do |module_signature|
      module_signature.included_modules.include?(expected_module)
    end
  end

  matcher :have_ancestors do |*expected_ancestors|
    match do |module_signature|
      module_signature.ancestors == expected_ancestors
    end
  end

  matcher :have_own_methods do |*expected_own_methods|
    match do |module_signature|
      module_signature.own_methods == expected_own_methods
    end
  end
end
