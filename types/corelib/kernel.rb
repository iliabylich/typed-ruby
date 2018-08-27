register_module(
  Signatures::Module.new(
    name: 'Kernel',
    included_modules: [],
    prepended_modules: [],
    own_methods: [

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

find_class('Object').include(find_module('Kernel'))
