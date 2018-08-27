require 'spec_helper'

RSpec.describe 'Types: Kernel' do
  include RegistryHelper

  subject(:mod) { find_module('Kernel') }

  it { is_expected.to have_ancestors( find_module('Kernel') ) }

  describe '#nil?' do
    subject(:method) { mod.find_method('nil?') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Boolean'))
    }
  end

  describe '#object_id' do
    subject(:method) { mod.find_method('object_id') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Integer'))
    }
  end
end
