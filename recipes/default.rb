#
# Cookbook:: kitchendockerdemo
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#extract_path = node['solr']['extract_path']


#directory '#{node['solr']['parent_dir']}' do
directory '/opt/apps/solr8' do
#  owner 'solrsvc'
#  group 'solrsvc'
  mode '0755'
  action :create
  recursive true
end


remote_file '/opt/apps/solr-8.9.0.tgz' do
  #source #{node['solr']['remote']['url']}
  source 'https://apache.claz.org/lucene/solr/8.9.0/solr-8.9.0.tgz'
  mode '0755'
  action :create
end

archive_file 'extract' do
  #path '#{extract_path}/solr-#{node['solr']['version']}.tgz'
  path '/opt/apps/solr-8.9.0.tgz'
  destination '/opt/apps'
end


