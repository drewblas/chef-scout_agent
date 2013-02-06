#
# Cookbook Name:: scout
# Recipe:: default

# create user and group
group node[:scout][:group] do
  action [ :create, :manage ]
end
user node[:scout][:user] do
  comment "Scout Agent"
  gid node[:scout][:group]
  home "/home/#{node[:scout][:user]}"
  supports :manage_home => true
  action [ :create, :manage ]
end

# install scout agent gem
gem_package "scout" do
  version node[:scout][:version]
  action :install
end

if node[:scout][:key]
  # initialize scout gem
  crontab_path = case node.platform
  when 'debian','ubuntu'
    "/var/spool/cron/crontabs/#{node[:scout][:user]}"
  when 'redhat','centos','fedora','scientific','suse','amazon'
    "/var/spool/cron/#{node[:scout][:user]}"
  end

  name_attr = node[:scout][:name] ? %{ --name="#{node[:scout][:name]}"} : ""
  server_attr = node[:scout][:server] ? %{ --server="#{node[:scout][:server]}"} : ""
  roles_attr = node[:scout][:roles] ? %{ --roles="#{node[:scout][:roles].map(&:to_s).join(',')}"} : ""
  
  code=nil
  bash "initialize scout" do
    code = <<-EOH
    #{node[:scout][:scout_bin]} #{node[:scout][:key]}#{name_attr}#{server_attr}#{roles_attr}
    EOH
    not_if do File.exist?(crontab_path) end
  end

  # schedule scout agent to run via cron
  cron "scout_run" do
    user node[:scout][:user]
    command code
    only_if do File.exist?(node[:scout][:scout_bin]) end
  end
else
  Chef::Log.warn "The agent will not report to scoutapp.com as a key wasn't provided. Provide a [:scout][:key] attribute to complete the install."
end

if node[:scout][:public_key]
  template "/home/#{node[:scout][:user]}/.scout/scout_rsa.pub" do
    source "scout_rsa.pub.erb"
    mode 0440
    owner node[:scout][:user]
    group node[:scout][:group]
    action :create
  end
end
