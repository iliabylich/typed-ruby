require 'spec_helper'

RSpec.describe 'Types: Object' do
  include RegistryHelper
  subject(:klass) { find_class('Object') }

  it { is_expected.to have_included(find_module('Kernel')) }
  its(:methods) { is_expected.to eq([]) }
end
