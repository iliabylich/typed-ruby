__String = find_class('String')

__String.define_method(
  Signatures::Method.new(
    name: '+',
    arguments: [
      Signatures::Arguments::Required.new(name: 'other', type: Types::InstanceOf.new(find_class('String')))
    ],
    returns: Types::InstanceOf.new(find_class('String'))
  )
)
