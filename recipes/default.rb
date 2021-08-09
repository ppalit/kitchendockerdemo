#
# Cookbook:: kitchendockerdemo
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
=begin

  bash 'extract_solr8' do
    cwd '/tmp'
    code <<-EOH
      mkdir -p /opt/apps/solr8
      aws s3 cp s3://DevOps-Software/solr/solr-8.9.0.tgz /tmp 
      tar xzf solr-8.9.0.tgz 
      cd solr-8.9.0/bin
      ./install_solr_service.sh /tmp/solr-8.9.0.tgz -i /opt/apps/solr8/ -d /opt/apps/solr8/live -u solrsvc -s solr8 -p 8983 -n
      chown solrsvc:solrsvc /etc/default/solr8.in.sh
      cd /opt/apps/solr8/solr-8.9.0/bin
      #./solr zk mkroot /cdp/solr8 -z 10.75.145.209:2181,10.75.126.79:2181,10.75.136.52:2181
      chown -R solrsvc:solrsvc  /opt/apps/solr8/solr-8.9.0
      EOH
    not_if 'ls /etc/init.d | grep -qx solr8'
  end

  bash 'solr_tar_gz' do
    code <<-EOH
    mkdir -p /opt/apps/apache-tomcat-7.0.52
    aws s3 cp s3://devops-dlyrepo/solr/tomcat/apache-tomcat-7.0.52.tar.gz /opt/apps/
    EOH
    not_if 'ls /etc/init.d | grep -qx tomcat'
  end

=end

decrypted_aws = Chef::EncryptedDataBagItem.load('aws', node.chef_environment)

extract_path = node['solr']['V8']['extract_path']

directory "#{node['solr']['V8']['parent_dir']}" do
  owner 'solrsvc'
  group 'solrsvc'
  mode '0755'
  action :create
  recursive true
end

aws_s3_file 'solr8_tar' do
  path "#{extract_path}"
  bucket node['solr']['V8']['s3']['bucket']
  remote_path node['solr']['V8']['s3']['solr8_file']
  aws_access_key_id decrypted_aws['aws_access_key_id']
  aws_secret_access_key decrypted_aws['aws_secret_access_key']
end

tar_extract "#{extract_path}/#{node['solr']['V8']['s3']['solr8_file']}" do
  action :extract_local
  compress_char 'z'
  target_dir #{extract_path}
  creates extract_path
end

execute 'install_solr' do
  command "#{extract_path}/solr-#{node['solr']['V8']['version']}/bin/install_solr_service.sh #{extract_path}/#{node['solr']['V8']['s3']['solr8_file']} -i #{node['solr']['V8']['parent_dir']} -d #{node['solr']['V8']['data_dir']} -u #{node['solr']['V8']['user']} -s #{node['solr']['V8']['service']} -p #{node['solr']['V8']['port']} -n"
  not_if { File.exist?('/etc/init.d/solr8') }
end

template '/etc/default/solr8.in.sh' do
  source 'solr8/solr8.in.sh.erb'
  owner 'solrsvc'
  group 'solrsvc'
  mode 0775
  variables({
    :zkUrl => node['solr']['V8']['zkp']['url'],
    :sslEnabled => node['solr']['V8']['zkp']['enabled'],
    :key_store => node[:solr][:V8][:ssl][:key_store],
    :key_store_password => node[:solr][:V8][:ssl][:key_store_password],
    :trust_store => node[:solr][:V8][:ssl][:truse_store],
    :trust_store_password => node[:solr][:V8][:ssl][:trust_store_password]
    })
end

=begin
  bash 'solr-core-lib-jars' do
    code <<-EOH
      cd /opt/apps/solr8/live/data 
      mkdir lib
      cd lib
      aws s3 cp https://s3.amazonaws.com/DevOps-Software/solr/sqljdbc4.jar /opt/apps/solr8/live/data/lib
      cp /opt/apps/solr8/solr-8.9.0/dist/solr-dataimporthandler-* .
    EOH
  end
=end

directory "#{node['solr']['V8']['data_dir']}/data/lib" do
  owner 'solrsvc'
  group 'solrsvc'
  mode '0755'
  recursive true
end

aws_s3_file 'sqljdbc' do
  path "#{node['solr']['V8']['data_dir']}/data/lib"
  bucket node['solr']['V8']['s3']['bucket']
  remote_path node['solr']['V8']['s3']['sqljdbc']
  aws_access_key_id decrypted_aws['aws_access_key_id']
  aws_secret_access_key decrypted_aws['aws_secret_access_key']
end

file "#{node['solr']['V8']['install_dir']}/dist/solr-dataimporthandler-#{node['solr']['V8']['version']}.jar" do
  owner 'solrsvc'
  group 'solrsvc'
  mode 0755
  action :create
end

file "#{node['solr']['V8']['install_dir']}/dist/solr-dataimporthandler-extras-#{node['solr']['V8']['version']}.jar" do
  owner 'solrsvc'
  group 'solrsvc'
  mode 0755
  action :create
end


=begin

  bash 'links' do
    code <<-EOH
      ln -s /opt/apps/solr8 solr
    EOH
  end
=end

link "#{node['solr']['V8']['parent_dir']}" do
  to "/opt/apps/solr"
end


=begin
  bash 'permission' do
    code <<-EOH
      chown -R solrsvc:solrsvc /opt/apps/solr8
      chown -R solrsvc:solrsvc /opt/apps/solr
    EOH
  end

   bash 'restart_server' do
    code <<-EOH
      service solr8 stop
      service solr8 start
    EOH
  end
=end
  
execute "chown-solr" do
  command "chown -R solrsvc:solrsvc #{node['solr']['V8']['parent_dir']}"
  user "solrsvc"
end

service 'solr8' do
  supports status: true
  ignore_failure false
  action :start
end

