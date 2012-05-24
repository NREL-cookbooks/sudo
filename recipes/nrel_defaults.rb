#
# Cookbook Name:: sudo
# Recipe:: nrel_defaults
#
# Copyright 2012, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

sudo "000-default" do
  template "nrel_defaults.erb"
end
