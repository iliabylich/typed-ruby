class BasicObject
end

class Object < BasicObject
end

class Boolean < Object
end

class Module < Object
end

class Class < Module
end

__RUBY__

  __BasicObject = find_type('BasicObject')
  __Class       = find_type('Class')

  __BasicObject.sclass.instance_eval { @superclass = __Class }

__RUBY__

class Integer < Object
end

class Array < Object
end

class String < Object
end
