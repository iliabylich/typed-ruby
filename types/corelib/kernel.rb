register_module(
  Signatures::Module.new(
    name: 'Kernel',
    included_modules: [],
    prepended_modules: [],
    methods: [

      Signatures::Method.new(
        name: 'nil?',
        arguments: [],
        returns: Types::InstanceOf.new('Boolean')
      ),

      Signatures::Method.new(
        name: 'object_id',
        arguments: [],
        returns: Types::InstanceOf.new('Integer')
      )

    ]
  )
)

find_class('Object').included_modules << find_module('Kernel')
