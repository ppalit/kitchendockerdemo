
docker_installation_tarball 'dcoker_in_kitchen' do
  action [:create]
  version "20.10.1"
  source "https://download.docker.com/linux/static/stable/aarch64/docker-20.10.1.tgz"
  checksum "ec2a42e52614e835b373f3f5c090e2f6a8a333ea52fa02ab9d8f4ac74a2f90d5"
end

docker_service 'docker_in_kitchen' do
  action :start
end

# Pull latest image
docker_image 'nginx' do
  tag 'latest'
  action :pull
  notifies :redeploy, 'docker_container[my_nginx_in_dokken]'
end

# Run container mapping containers port 80 to the host's port 80
docker_container 'my_nginx_in_dokken' do
  repo 'nginx'
  tag 'latest'
  port [ '8080:80' ]
end