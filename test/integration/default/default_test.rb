# InSpec test for recipe kitchendockerdemo::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe docker_service('docker_in_kitchen') do
  it { should exist }
end

describe docker_container('my_nginx') do
  it { should exist }
  it { should be_running }
end