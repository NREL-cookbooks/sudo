#
# Cookbook Name:: sudo
# Recipe:: afdc_deployment
#
# Copyright 2012, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "sudo"

sudo "afdc_deployment" do
  group 'AFDC\ Developers'
  commands ["/sbin/service httpd reload", "/etc/init.d/monit stop", "/etc/init.d/monit start", "/usr/bin/monit", "/usr/bin/supervisorctl", "/usr/local/bin/supervisorctl_rolling_restart", "/etc/init.d/haproxy", "/etc/init.d/nginx"]
  host "ALL"
  nopasswd true
end
