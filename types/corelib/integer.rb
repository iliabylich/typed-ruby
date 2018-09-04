__Integer = find_class('Integer')

__Integer.define_method(
  Signatures::Method.new(
    name: '+',
    arguments: [
      Signatures::Arguments::Required.new(name: 'other', type: Types::InstanceOf.new(__Integer))
    ],
    returns: Types::InstanceOf.new(__Integer)
  )
)
