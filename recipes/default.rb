#
# Cookbook:: kitchendockerdemo
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
file '/tmp/readme.txt' do
    content 'Created for demo!'
    action :create
end