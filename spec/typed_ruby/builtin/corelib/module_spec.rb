require 'spec_helper'

RSpec.describe 'Types: Module' do
  include RegistryHelper

  subject(:mod) { find_class('Module') }

  it {
    is_expected.to have_ancestors(
      find_class('Module'),
      find_class('Object'),
      find_module('Kernel'),
      find_class('BasicObject')
    )
  }

  describe '#name' do
    subject(:method) { mod.find_method('name') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of(find_class('String')))
    }
  end
end
