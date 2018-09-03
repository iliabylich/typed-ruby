register_class(
  __BasicObject = Signatures::Class.new(
    name: 'BasicObject',
    superclass: nil
  )
)

register_class(
  __Object = Signatures::Class.new(
    name: 'Object',
    superclass: find_class('BasicObject')
  )
)

register_class(
  __Boolean = Signatures::Class.new(
    name: 'Boolean',
    superclass: find_class('Object')
  )
)

register_class(
  __Module = Signatures::Class.new(
    name: 'Module',
    superclass: find_class('Object')
  )
)

register_class(
  __Class = Signatures::Class.new(
    name: 'Class',
    superclass: find_class('Module')
  )
)

__BasicObject.sclass.instance_eval { @superclass = __Class }

register_class(
  __Integer = Signatures::Class.new(
    name: 'Integer',
    superclass: find_class('Object')
  )
)

register_class(
  __String = Signatures::Class.new(
    name: 'String',
    superclass: find_class('Object')
  )
)

register_class(
  __Array = Signatures::Class.new(
    name: 'Array',
    superclass: find_class('Object')
  )
)
