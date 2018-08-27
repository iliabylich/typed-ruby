require 'spec_helper'

RSpec.describe 'Types: Object' do
  include RegistryHelper

  subject(:klass) { find_class('Object') }

  it { is_expected.to have_ancestors( find_class('Object'), find_module('Kernel'), find_class('BasicObject') ) }
  its(:own_methods) { is_expected.to eq([]) }
end
