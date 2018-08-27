require 'spec_helper'

RSpec.describe 'Types: Class' do
  include RegistryHelper

  subject(:mod) { find_class('Class') }

  it {
    is_expected.to have_ancestors(
      find_class('Class'),
      find_class('Module'),
      find_class('Object'),
      find_module('Kernel'),
      find_class('BasicObject')
    )
  }

  describe '#new' do
    subject(:method) { mod.find_method('new') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Class'))
    }
  end

  describe '#allocate' do
    subject(:method) { mod.find_method('allocate') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Class'))
    }
  end

  describe '#superclass' do
    subject(:method) { mod.find_method('superclass') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Class'))
    }
  end
end
