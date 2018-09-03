__BasicObjet = find_class('BasicObject')

__BasicObjet.define_method(
  Signatures::Method.new(
    name: '!',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Boolean'))
  )
)

__BasicObjet.define_method(
  Signatures::Method.new(
    name: '!=',
    arguments: [
      Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
    ],
    returns: Types::InstanceOf.new(find_class('Boolean'))
  )
)

__BasicObjet.define_method(
  Signatures::Method.new(
    name: '==',
    arguments: [
      Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
    ],
    returns: Types::InstanceOf.new(find_class('Boolean'))
  )
)

__BasicObjet.define_method(
  Signatures::Method.new(
    name: '__id__',
    arguments: [],
    returns: Types::InstanceOf.new(find_class('Integer'))
  )
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: '__send__')
)

__BasicObjet.define_method(
  Signatures::Method.new(
    name: 'equal?',
    arguments: [
      Signatures::Arguments::Required.new(name: 'other', type: Types::ANY)
    ],
    returns: Types::InstanceOf.new(find_class('Boolean'))
  )
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: 'instance_eval')
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: 'instance_exec')
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: 'method_missing')
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: 'singleton_method_added')
)

__BasicObjet.define_method(
  Signatures::AnyMethod.new(name: 'singleton_method_removed')
)

