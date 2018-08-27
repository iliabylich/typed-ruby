register_module(
  Signatures::Module.new(
    name: 'Kernel',
    included_modules: [],
    prepended_modules: [],
    sclass_methods: [],
    own_methods: [
      Signatures::AnyMethod.new(name: '!~'),
      Signatures::AnyMethod.new(name: '<=>'),
      Signatures::AnyMethod.new(name: '==='),
      Signatures::AnyMethod.new(name: '=~'),
      Signatures::AnyMethod.new(name: 'class'),
      Signatures::AnyMethod.new(name: 'clone'),
      Signatures::AnyMethod.new(name: 'define_singleton_method'),
      Signatures::AnyMethod.new(name: 'display'),
      Signatures::AnyMethod.new(name: 'dup'),
      Signatures::AnyMethod.new(name: 'enum_for'),
      Signatures::AnyMethod.new(name: 'eql?'),
      Signatures::AnyMethod.new(name: 'extend'),
      Signatures::AnyMethod.new(name: 'freeze'),
      Signatures::AnyMethod.new(name: 'frozen?'),
      Signatures::AnyMethod.new(name: 'hash'),
      Signatures::AnyMethod.new(name: 'inspect'),
      Signatures::AnyMethod.new(name: 'instance_of?'),
      Signatures::AnyMethod.new(name: 'instance_variable_defined?'),
      Signatures::AnyMethod.new(name: 'instance_variable_get'),
      Signatures::AnyMethod.new(name: 'instance_variable_set'),
      Signatures::AnyMethod.new(name: 'instance_variables'),
      Signatures::AnyMethod.new(name: 'is_a?'),
      Signatures::AnyMethod.new(name: 'itself'),
      Signatures::AnyMethod.new(name: 'kind_of?'),
      Signatures::AnyMethod.new(name: 'method'),
      Signatures::AnyMethod.new(name: 'methods'),

      Signatures::Method.new(
        name: 'nil?',
        arguments: [],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: 'object_id',
        arguments: [],
        returns: Types::InstanceOf.new('Integer')
      ),

      Signatures::AnyMethod.new(name: 'pp'),
      Signatures::AnyMethod.new(name: 'private_methods'),
      Signatures::AnyMethod.new(name: 'protected_methods'),
      Signatures::AnyMethod.new(name: 'public_method'),
      Signatures::AnyMethod.new(name: 'public_methods'),
      Signatures::AnyMethod.new(name: 'public_send'),
      Signatures::AnyMethod.new(name: 'remove_instance_variable'),
      Signatures::AnyMethod.new(name: 'respond_to?'),
      Signatures::AnyMethod.new(name: 'send'),
      Signatures::AnyMethod.new(name: 'singleton_class'),
      Signatures::AnyMethod.new(name: 'singleton_method'),
      Signatures::AnyMethod.new(name: 'singleton_methods'),
      Signatures::AnyMethod.new(name: 'taint'),
      Signatures::AnyMethod.new(name: 'tainted?'),
      Signatures::AnyMethod.new(name: 'tap'),
      Signatures::AnyMethod.new(name: 'to_enum'),
      Signatures::AnyMethod.new(name: 'to_s'),
      Signatures::AnyMethod.new(name: 'trust'),
      Signatures::AnyMethod.new(name: 'untaint'),
      Signatures::AnyMethod.new(name: 'untrust'),
      Signatures::AnyMethod.new(name: 'untrusted?'),
      Signatures::AnyMethod.new(name: 'yield_self'),
    ]
  )
)

find_class('Object').include(find_module('Kernel'))
