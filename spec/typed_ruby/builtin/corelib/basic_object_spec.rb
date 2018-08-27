require 'spec_helper'

RSpec.describe 'Types: BasicObject', type: 'BasicObject' do
  include TypeHelper

  describe '#!', method: '!' do
    it_is_defined
    it_takes      { [] }
    it_returns    { instance_of('Boolean') }
  end

  describe '#!=', method: '!=' do
    it_is_defined
    it_takes      { [any] }
    it_returns    { instance_of('Boolean') }
  end

  describe '#==', method: '==' do
    it_is_defined
    it_takes      { [any] }
    it_returns    { instance_of('Boolean') }
  end

  describe '#__id__', method: '__id__' do
    it_is_defined
    it_takes      { [] }
    it_returns    { instance_of('Integer') }
  end

  # describe '#__send__', method: '__send__' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  describe '#equal?', method: 'equal?' do
    it_is_defined
    it_takes      { [any] }
    it_returns    { instance_of('Boolean') }
  end

  # describe '#instance_eval', method: 'instance_eval' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  # describe '#instance_exec', method: 'instance_exec' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  # describe '#method_missing', method: 'method_missing' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  # describe '#singleton_method_added', method: 'singleton_method_added' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  # describe '#singleton_method_removed', method: 'singleton_method_removed' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end

  # describe '#singleton_method_undefined', method: 'singleton_method_undefined' do
  #   it_is_defined
  #   it_takes      { [] }
  #   it_returns    { instance_of('Boolean') }
  # end
end
