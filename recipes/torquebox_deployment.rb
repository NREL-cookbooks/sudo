#
# Cookbook Name:: sudo
# Recipe:: torquebox_deploymnet
#
# Copyright 2013, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"
include_recipe "torquebox"

sudo "torquebox_deployment" do
  group 'AFDC\ Developers'

  commands [
    "/bin/rm -f #{node[:torquebox][:dir]}/home/jboss/standalone/deployments/*-knob.yml*",
  ]

  host "ALL"
  nopasswd true
end
