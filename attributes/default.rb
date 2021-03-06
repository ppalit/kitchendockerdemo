
default['solr']['zkp']['url'] = "zkp:2181/dev/solr8"
default['solr']['ssl']['enabled'] = 'true'
default['solr']['ssl']['key_store'] = 'etc/solr-ssl.keystore.p12'
default['solr']['ssl']['key_store_password'] = 'secret'
default['solr']['ssl']['truse_store'] = 'etc/solr-ssl.keystore.p12'
default['solr']['ssl']['trust_store_password'] = 'secret'
default['solr']['remote']['url'] = 'https://apache.claz.org/lucene/solr/8.9.0/solr-8.9.0.tgz'
default['solr']['version'] = '8.9.0'
default['solr']['extract_path'] = '/opt/apps'
default['solr']['parent_dir'] = '/opt/apps/solr8'
default['solr']['install_dir'] = '/opt/apps/solr8/solr8'
default['solr']['data_dir'] = '/opt/apps/solr8/live'
default['solr']['user'] = 'solrsvc'
default['solr']['service'] = 'solr8'
default['solr']['port'] = '8983'
