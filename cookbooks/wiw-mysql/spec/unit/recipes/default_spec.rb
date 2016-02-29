require 'spec_helper'

describe 'wiw-mysql::default' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    )
    runner.node.set['chef-vault']['databag_fallback'] = true
    runner.node.set['wiw_mysql']['username'] = 'wiw'
    runner.node.set['wiw_mysql']['tablename'] = 'wiw'
    runner.node.set['wiw_mysql']['password_vault'] = 'mysql'
    runner.node.set['wiw_mysql']['service_name'] = 'default'
    runner.converge(described_recipe)
  end

  before do
    allow(Chef::DataBag).to receive(:load).with('mysql').and_return(
      default: { root: 'abc123', wiw: 'abc123' }
    )
    allow(Chef::DataBagItem).to receive(:load).with('mysql', 'default').and_return(
      root: 'abc123',
      wiw: 'abc123'
    )
  end

  it 'created a service resource' do
    expect(chef_run).to start_mysql_service('default')
  end

  it 'created a user' do
    expect(chef_run).to create_mysql_database_user('wiw')
  end

  it 'created a database' do
    expect(chef_run).to create_mysql_database('wiw')
  end
end
