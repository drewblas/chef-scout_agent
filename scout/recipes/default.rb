#
# Cookbook Name:: scout
# Recipe:: default

Chef::Log.info "Loading: #{cookbook_name}::#{recipe_name}"


# create group and user
group node[:scout][:group] do
  action [ :create, :manage ]
end.run_action(:create)

user node[:scout][:user] do
  comment "Scout Agent"
  gid node[:scout][:group]
  home "/home/#{node[:scout][:user]}"
  supports :manage_home => true
  action [ :create, :manage ]
  only_if do node[:scout][:user] != 'root' end
end.run_action(:create)

# install scout agent gem
gem_package "scout" do
  if node[:scout][:rvm_wrapper]
    gem_binary File.join(node[:scout][:rvm_wrapper],"gem")
  else
    gem_binary File.join(RbConfig::CONFIG['bindir'],"gem")
  end
  version node[:scout][:version]
  action :upgrade
end

if node[:scout][:key]
  rvm_wrapper = node[:scout][:rvm_wrapper] ? node[:scout][:rvm_wrapper] : ""
  if rvm_wrapper and File.exist?(File.join(rvm_wrapper, "scout"))
    scout_bin = File.join(rvm_wrapper, "scout")
  elsif node[:scout][:bin] and File.exist?(node[:scout][:bin])
    scout_bin = node[:scout][:bin]
  elsif File.exist?("#{Gem.default_bindir}/scout")
    scout_bin = "#{Gem.default_bindir}/scout"
  else
    scout_bin = ""
  end
  name_attr = node[:scout][:name] ? %{ --name "#{node[:scout][:name]}"} : ""
  server_attr = node[:scout][:server] ? %{ --server "#{node[:scout][:server]}"} : ""
  roles_attr = node[:scout][:roles] ? %{ --roles "#{node[:scout][:roles].map(&:to_s).join(',')}"} : ""
  http_proxy_attr = node[:scout][:http_proxy] ? %{ --http-proxy "#{node[:scout][:http_proxy]}"} : ""
  https_proxy_attr = node[:scout][:https_proxy] ? %{ --https-proxy "#{node[:scout][:https_proxy]}"} : ""
  environment_attr = node[:scout][:environment] ? %{ --environment "#{node[:scout][:environment]}"} : ""

  # schedule scout agent to run via cron
  cron "scout_run" do
    user node[:scout][:user]
    command "#{scout_bin} #{node[:scout][:key]}#{name_attr}#{server_attr}#{roles_attr}#{http_proxy_attr}#{https_proxy_attr}#{environment_attr}"
    only_if do File.exist?(scout_bin) end
  end
else
  Chef::Log.warn "The agent will not report to scoutapp.com as a key wasn't provided. Provide a [:scout][:key] attribute to complete the install."
end

if node[:scout][:public_key]
  home_dir = Dir.respond_to?(:home) ? Dir.home(node[:scout][:user]) : File.expand_path("~#{node[:scout][:user]}")
  data_dir = "#{home_dir}/.scout"
  # create the .scout directory
  directory data_dir do
    group node[:scout][:group]
    owner node[:scout][:user]
    mode "0755"
  end
  template "#{data_dir}/scout_rsa.pub" do
    source "scout_rsa.pub.erb"
    mode 0440
    owner node[:scout][:user]
    group node[:scout][:group]
    action :create
  end
end

if node[:scout][:delete_on_shutdown]
  gem_package 'scout_api'
  template "/etc/rc0.d/scout_shutdown" do
    source "scout_shutdown.erb"
    owner "root"
    group "root"
    mode 0755
  end
else
  bash "delete_scout_shutdown" do
    user "root"
    code "rm -f /etc/rc0.d/scout_shutdown"
  end
end

(node[:scout][:plugin_gems] || []).each do |gemname|
  gem_package gemname
end

# Create plugin lookup properties
directory "/home/#{node[:scout][:user]}/.scout" do
  owner node[:scout][:user]
  group node[:scout][:group]
  recursive true
end
template "/home/#{node[:scout][:user]}/.scout/plugins.properties" do
  source "plugins.properties.erb"
  mode 0664
  owner node[:scout][:user]
  group node[:scout][:group]
  variables lazy {
    plugin_properties = {}
    node['scout']['plugin_properties'].each do |property, lookup_hash|
      plugin_properties[property] = Chef::EncryptedDataBagItem.load(lookup_hash[:encrypted_data_bag], lookup_hash[:item])[lookup_hash[:key]]
    end
    {
      plugin_properties: plugin_properties
    }
  }
  action :create
end
