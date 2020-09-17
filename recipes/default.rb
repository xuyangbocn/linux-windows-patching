#
# Cookbook:: node-patching
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#
case node['platform']
when 'rhel', 'amazon', 'ubuntu'
        include_recipe 'node-patching::linux-patching'
when 'windows'
        include_recipe 'node-patching::windows-patching'
end
