require 'spec_helper'
describe 'webmin' do
  context 'with default values for all parameters' do
    it { should contain_class('webmin') }
  end
end
