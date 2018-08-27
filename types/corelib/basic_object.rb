register_class(
  Signatures::Class.new(
    name: 'BasicObject',
    superclass: nil,
    included_modules: [],
    prepended_modules: [],
    sclass_methods: [],
    own_methods: [

      Signatures::Method.new(
        name: '!',
        arguments: [],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '!=',
        arguments: [
          Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
        ],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '==',
        arguments: [
          Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
        ],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '__id__',
        arguments: [],
        returns: Types::InstanceOf.new('Integer')
      ),

      Signatures::AnyMethod.new(name: '__send__'),

      Signatures::Method.new(
        name: 'equal?',
        arguments: [
          Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
        ],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::AnyMethod.new(name: 'instance_eval'),
      Signatures::AnyMethod.new(name: 'instance_exec'),
      Signatures::AnyMethod.new(name: 'method_missing'),
      Signatures::AnyMethod.new(name: 'singleton_method_added'),
      Signatures::AnyMethod.new(name: 'singleton_method_removed'),

    ]
  )
)
