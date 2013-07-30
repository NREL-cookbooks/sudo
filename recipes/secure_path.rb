#
# Cookbook Name:: sudo
# Recipe:: secure_path
#
# Copyright 2012, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

if(node.recipe?("rbenv::system"))
  # Add the RVM path, but only if it doesn't already exist. This array uniq
  # approach deals with nodes where this had gotten appended multiple times.
  path = "#{node[:rbenv][:root_path]}/shims:#{node[:rbenv][:root_path]}/bin:/usr/local/bin:#{node[:authorization][:sudo][:secure_path]}"
  path = path.split(":").uniq.join(":")
  node.set[:authorization][:sudo][:secure_path] = path
end

if(node.recipe?("subversion::collabnet_client"))
  # Add the Collabnet path, but only if it doesn't already exist.
  path = "#{node[:subversion][:collabnet][:prefix]}/bin:#{node[:authorization][:sudo][:secure_path]}"
  path = path.split(":").uniq.join(":")
  node.set[:authorization][:sudo][:secure_path] = path
end

if(node.recipe?("postgresql::server"))
  if(node[:postgresql][:install_repo] == "pgdg")
    # Add the postgresql path, but only if it doesn't already exist.
    path = "/usr/pgsql-#{node[:postgresql][:version]}/bin:#{node[:authorization][:sudo][:secure_path]}"
    path = path.split(":").uniq.join(":")
    node.set[:authorization][:sudo][:secure_path] = path
  end
end

sudo "secure_path" do
  template "secure_path.erb"
  variables(
    :secure_path => node[:authorization][:sudo][:secure_path],
  )
end
