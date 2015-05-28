require 'spec_helper'
describe 'proxmox' do

  context 'with defaults for all parameters' do
    it { should contain_class('proxmox') }
  end
end
