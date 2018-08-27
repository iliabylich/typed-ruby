register_class(
  Signatures::Class.new(
    name: 'Class',
    superclass: find_class('Module'),
    included_modules: [],
    prepended_modules: [],
    own_methods: [
      Signatures::Method.new(
        name: 'new',
        arguments: [],
        returns: Types::InstanceOf.new('Class')
      ),
      Signatures::Method.new(
        name: 'allocate',
        arguments: [],
        returns: Types::InstanceOf.new('Class')
      ),
      Signatures::Method.new(
        name: 'superclass',
        arguments: [],
        returns: Types::InstanceOf.new('Class')
      ),
    ]
  )
)