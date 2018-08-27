require 'spec_helper'

RSpec.describe 'Types: Object' do
  include RegistryHelper
  subject(:klass) { find_class('Object') }

  its(:ancestors) {
    is_expected.to eq([
      find_class('Object'),
      find_module('Kernel'),
      find_class('BasicObject')
    ])
  }
  its(:own_methods) { is_expected.to eq([]) }
end
