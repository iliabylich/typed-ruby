require 'spec_helper'

RSpec.describe 'Types: Kernel' do
  include RegistryHelper

  subject(:mod) { find_module('Kernel') }

  its(:ancestors) { is_expected.to eq([ find_module('Kernel') ]) }

  # !~
  # <=>
  # ===
  # =~
  # class
  # clone
  # define_singleton_method
  # display
  # dup
  # enum_for
  # eql?
  # extend
  # freeze
  # frozen?
  # hash
  # inspect
  # instance_of?
  # instance_variable_defined?
  # instance_variable_get
  # instance_variable_set
  # instance_variables
  # is_a?
  # itself
  # kind_of?
  # method
  # methods

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

  # pp
  # private_methods
  # protected_methods
  # public_method
  # public_methods
  # public_send
  # remove_instance_variable
  # respond_to?
  # send
  # singleton_class
  # singleton_method
  # singleton_methods
  # taint
  # tainted?
  # tap
  # to_enum
  # to_s
  # trust
  # untaint
  # untrust
  # untrusted?
  # yield_self
end
