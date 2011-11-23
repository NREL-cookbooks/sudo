#
# Cookbook Name:: sudo
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "sudo" do
  action :upgrade
end

# When using RVM, force it onto the sudo path so installed gems can be run via
# sudo. Previous version of RVM used to install binary wrappers into
# /usr/local/bin, so sudo picked up on them, but newer versions of RVM don't
# seem to to do this.
if(node[:recipes].include?("rvm::install") || node.recipe?("rvm::install"))
  node.set[:authorization][:sudo][:secure_path] = "/srv/developer/rvm/bin:#{node[:authorization][:sudo][:secure_path]}"
end

# If sudo needs a custom PATH set and we're currently running chef-client
# inside sudo, force set this new PATH variable. Our replacement for
# /etc/sudoers will fix this for future runs, but in the current run, we still
# need to fix this environment variable. This fixes run issues with /sbin
# missing from RHEL: http://tickets.opscode.com/browse/OHAI-87
if(node[:authorization][:sudo][:secure_path] && ENV["SUDO_USER"] && node[:authorization][:sudo][:secure_path] != ENV["PATH"])
  ENV["PATH"] = node[:authorization][:sudo][:secure_path]

  # With the new PATH in place, reload all the Ohai settings. This will make
  # sure the node[:ipaddress] is picked up on RHEL systems.
  ohai = Ohai::System.new
  ohai.all_plugins
  node.automatic_attrs.merge! ohai.data
end

# Install the sudoers template into a temporary location.
template "#{Chef::Config[:file_cache_path]}/sudoers" do
  source "sudoers.erb"
  mode "0440"
  owner "root"
  group "root"
  backup false
end

template "/etc/sudoers" do
  # Only install the real file if the temp copy passes visudo's check. This
  # should hopefully prevent us from totally breaking sudo during all this
  # automation.
  only_if "visudo -c -f #{Chef::Config[:file_cache_path]}/sudoers", :environment => { "PATH" => "/usr/sbin:/usr/bin:/sbin:/bin" }

  source "sudoers.erb"
  mode "0440"
  owner "root"
  group "root"
end
