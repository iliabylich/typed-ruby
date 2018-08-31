register_class(
  Signatures::Class.new(
    name: 'String',
    superclass: find_class('Object'),
    included_modules: [],
    prepended_modules: [],
    sclass_methods: [],
    own_methods: [

      Signatures::Method.new(
        name: '+',
        arguments: [
          Signatures::Arguments::Required.new(name: 'other', type: Types::InstanceOf.new('String'))
        ],
        returns: Types::InstanceOf.new('String')
      ),

    ]
  )
)
