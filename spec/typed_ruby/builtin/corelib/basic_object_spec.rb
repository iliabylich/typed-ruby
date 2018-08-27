require 'spec_helper'

RSpec.describe 'Types: BasicObject' do
  include RegistryHelper
  let(:klass) { find_class('BasicObject') }

  describe '#!' do
    subject(:method) { klass.find_method('!') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Boolean'))
    }
  end

  describe '#!=' do
    subject(:method) { klass.find_method('!=') }

    it {
      is_expected.to be_defined
        .and take_arguments([any])
        .and return_type(instance_of('Boolean'))
    }
  end

  describe '#==' do
    subject(:method) { klass.find_method('==') }

    it {
      is_expected.to be_defined
        .and take_arguments([any])
        .and return_type(instance_of('Boolean'))
    }
  end

  describe '#__id__' do
    subject(:method) { klass.find_method('__id__') }

    it {
      is_expected.to be_defined
        .and take_arguments([])
        .and return_type(instance_of('Integer'))
    }
  end

  describe '#__send__' do
    subject(:method) { klass.find_method('__send__') }

    it { is_expected.to be_any_method }
  end

  describe '#equal?' do
    subject(:method) { klass.find_method('equal?') }

    it {
      is_expected.to be_defined
        .and take_arguments([any])
        .and return_type(instance_of('Boolean'))
    }
  end

  describe '#instance_eval' do
    subject(:method) { klass.find_method('instance_eval') }

    it { is_expected.to be_any_method }
  end

  describe '#instance_exec' do
    subject(:method) { klass.find_method('instance_exec') }

    it { is_expected.to be_any_method }
  end

  describe '#method_missing' do
    subject(:method) { klass.find_method('method_missing') }

    it { is_expected.to be_any_method }
  end

  describe '#singleton_method_added' do
    subject(:method) { klass.find_method('singleton_method_added') }

    it { is_expected.to be_any_method }
  end

  describe '#singleton_method_removed' do
    subject(:method) { klass.find_method('singleton_method_removed') }

    it { is_expected.to be_any_method }
  end

  describe '#singleton_method_undefined' do
    subject(:method) { klass.find_method('__send__') }

    it { is_expected.to be_any_method }
  end
end
