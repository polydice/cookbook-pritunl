if platform_family?("debian")
  apt_repository "pritunl" do
    uri          "http://ppa.launchpad.net/pritunl/ppa/ubuntu"
    distribution node["lsb"]["codename"]
    components   ["main"]
    keyserver    "keyserver.ubuntu.com"
    key          "C5B39158"
  end
  apt_package "pritunl"
elsif platform_family?("rhel")
  include_recipe 'yum-epel'
  remote_file "#{Chef::Config[:file_cache_path]}/pritunl.rpm" do
    source "http://pritunl.com/bin/pritunl-0.10.12-1.el7.centos.x86_64.rpm"
    action :create
  end

  yum_package "pritunl" do
    source "#{Chef::Config[:file_cache_path]}/pritunl.rpm"
    action :install
  end
end

service "pritunl" do
  provider Chef::Provider::Service::Upstart if platform?("ubuntu")
  supports :status => true, :restart => true
  action [:enable, :start]
end

