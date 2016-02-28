require 'spec_helper'

describe 'wiw-nginx::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  before do
    stub_command('which nginx').and_return(nil)
  end

  it 'installs nginx' do
    expect(chef_run).to install_package('nginx')
  end

  it 'start nginx' do
    expect(chef_run).to start_service('nginx')
  end

  it 'updates logrotate template' do
    expect(chef_run).to create_template('/etc/logrotate.d/nginx').with_user('root')
  end

  # This test is a bit fragile, but if it breaks when the nginx cookbook is updated
  # then we probably have to make some changes to the wrapper cookbook
  it 'disables default nginx site' do
    expect(chef_run).to run_execute('nxdissite default')
  end
end
