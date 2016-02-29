require 'spec_helper'

describe 'wiw-blog::install_wordpress' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '14.04',
      file_cache_path: '/var/chef/cache'
    )

    runner.node.set['wiw_blog']['wordpress_version'] = '4.4.2'
    runner.node.set['wiw_blog']['wordpress_source_base'] = 'https://example.com'
    runner.converge(described_recipe)
  end

  it 'should download wordpress' do
    expect(chef_run).to create_remote_file('/var/chef/cache/wordpress-4.4.2.tar.gz')
      .with(source: 'https://example.com/wordpress-4.4.2.tar.gz')
  end

  it 'should create wordpress root dir' do
    expect(chef_run).to create_directory('/opt/wordpress')
  end

  it 'should extract and link wordpress' do
    expect(chef_run).to run_bash('extract wordpress')
  end
end
