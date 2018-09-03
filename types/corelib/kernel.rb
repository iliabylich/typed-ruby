register_module(
  __Kernel = Signatures::Module.new(
    name: 'Kernel'
  )
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: '!~')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: '<=>')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: '===')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: '=~')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'class')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'clone')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'define_singleton_method')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'display')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'dup')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'enum_for')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'eql?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'extend')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'freeze')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'frozen?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'hash')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'inspect')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'instance_of?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'instance_variable_defined?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'instance_variable_get')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'instance_variable_set')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'instance_variables')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'is_a?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'itself')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'kind_of?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'method')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'methods')
)

__Kernel.define_method(
  Signatures::Method.new(
    name: 'nil?',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Boolean'))
  )
)

__Kernel.define_method(
  Signatures::Method.new(
    name: 'object_id',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Integer'))
  )
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'pp')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'private_methods')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'protected_methods')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'public_method')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'public_methods')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'public_send')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'remove_instance_variable')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'respond_to?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'send')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'singleton_class')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'singleton_method')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'singleton_methods')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'taint')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'tainted?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'tap')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'to_enum')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'to_s')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'trust')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'untaint')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'untrust')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'untrusted?')
)

__Kernel.define_method(
  Signatures::AnyMethod.new(name: 'yield_self')
)

find_class('Object').include(__Kernel)
