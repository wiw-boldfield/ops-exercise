require 'spec_helper'

describe 'wiw-blog::install_anchorcms' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04',
      file_cache_path: '/var/chef/cache'
    )

    runner.node.set['wiw_blog']['anchorcms_version'] = '0.12.1'
    runner.node.set['wiw_blog']['anchorcms_source_base'] = 'https://example.com/anchorcms'
    runner.converge(described_recipe)
  end

  it 'should download anchorcms' do
    expect(chef_run).to create_remote_file('/var/chef/cache/anchorcms-0.12.1.tar.gz')
      .with(source: 'https://example.com/anchorcms/0.12.1.tar.gz')
  end

  it 'should create anchorcms root dir' do
    expect(chef_run).to create_directory('/opt/anchorcms')
  end

  it 'should extract and link anchorcms' do
    expect(chef_run).to run_bash('extract anchorcms')
  end
end
