require 'spec_helper'

describe 'wiw-hhvm::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  it 'installs hhvm' do
    expect(chef_run).to install_package('hhvm')
  end

  it 'updates file perms' do
    expect(chef_run).to run_bash('fix hhvm file perms')
  end
end

describe 'wiw-hhvm::logrotate' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  it 'creates logrotate template' do
    expect(chef_run).to create_template('/etc/logrotate.d/hhvm').with_user('root')
  end
end

describe 'wiw-hhvm::service' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  it 'enable hhvm' do
    expect(chef_run).to enable_service('hhvm')
  end
end

describe 'wiw-hhvm::socket' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end

  it 'updates hhvm server.ini' do
    expect(chef_run).to create_template('/etc/hhvm/server.ini').with_user('www-data')
  end
end

describe 'wiw-hhvm::fastcgi' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04'
    ).converge(described_recipe)
  end
  it 'installs fastcgi modules' do
    expect(chef_run).to run_execute('install fastcgi')
  end

  it 'updates nginx hhvm conf' do
    expect(chef_run).to create_template('/etc/nginx/hhvm.conf').with_user('www-data')
  end

  it 'updates apache hhvm conf' do
    expect(chef_run).to create_template('/etc/apache2/mods-available/hhvm_proxy_fcgi.conf').with_user('www-data')
  end
end
