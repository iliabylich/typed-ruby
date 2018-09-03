__Class = find_class('Class')

__Class.define_method(
  Signatures::Method.new(
    name: 'new',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Class'))
  )
)

__Class.define_method(
  Signatures::Method.new(
    name: 'allocate',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Class'))
  )
)

__Class.define_method(
  Signatures::Method.new(
    name: 'superclass',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Class'))
  )
)
