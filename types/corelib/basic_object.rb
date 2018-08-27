register_class(
  Signatures::Class.new(
    name: 'BasicObject',
    superclass: nil,
    included_modules: [],
    prepended_modules: [],
    methods: [

      Signatures::Method.new(
        name: '!',
        arguments: [],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '!=',
        arguments: [Types::ANY],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '==',
        arguments: [Types::ANY],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: '__id__',
        arguments: [],
        returns: Types::InstanceOf.new('Integer')
      ),

      # __send__

      Signatures::Method.new(
        name: 'equal?',
        arguments: [Types::ANY],
        returns: Types::InstanceOf.new('Boolean')
      ),

      # instance_eval

    ]
  )
)
