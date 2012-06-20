#
# Cookbook Name:: sudo
# Recipe:: secure_path
#
# Copyright 2012, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

if(node[:recipes].include?("rvm::install") || node.recipe?("rvm::install"))
  # Add the RVM path, but only if it doesn't already exist. This array uniq
  # approach deals with nodes where this had gotten appended multiple times.
  path = "/usr/local/rvm/bin:#{node[:authorization][:sudo][:secure_path]}"
  path = path.split(":").uniq.join(":")
  node.set[:authorization][:sudo][:secure_path] = path
end

if(node[:recipes].include?("rbenv") || node.recipe?("rbenv"))
  # Add the RVM path, but only if it doesn't already exist. This array uniq
  # approach deals with nodes where this had gotten appended multiple times.
  path = "#{node[:rbenv][:install_prefix]}/rbenv/shims:#{node[:rbenv][:install_prefix]}/rbenv/bin:#{node[:ruby_build][:prefix]}/bin:#{node[:authorization][:sudo][:secure_path]}"
  path = path.split(":").uniq.join(":")
  node.set[:authorization][:sudo][:secure_path] = path
end

if(node[:recipes].include?("subversion::collabnet_client") || node.recipe?("subversion::collabnet_client"))
  # Add the Collabnet path, but only if it doesn't already exist.
  path = "#{node[:subversion][:collabnet][:prefix]}/bin:#{node[:authorization][:sudo][:secure_path]}"
  path = path.split(":").uniq.join(":")
  node.set[:authorization][:sudo][:secure_path] = path
end

if(node[:recipes].include?("postgresql::server") || node.recipe?("postgresql::server"))
  if(node[:postgresql][:install_repo] == "pgdg")
    # Add the postgresql path, but only if it doesn't already exist.
    path = "/usr/pgsql-#{node[:postgresql][:version]}/bin:#{node[:authorization][:sudo][:secure_path]}"
    path = path.split(":").uniq.join(":")
    node.set[:authorization][:sudo][:secure_path] = path
  end
end

sudo "secure_path" do
  template "secure_path.erb"
end
