#
# Cookbook:: linux-patching
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#
if tagged?('do_patch')

  log_dir = "/var/log/patching/#{Time.new.strftime("%Y-%m-%d")}"
  patch_script = '/patch_linux.sh'

  directory log_dir do
    action :create
    recursive true
  end

  # Reboots server only if notified
  reboot 'now' do
    delay_mins 2
    action :nothing
    reason 'Chef has requested reboot.'
  end

  # Deploy patching script to server
  template patch_script do
    source 'patch_linux.sh.erb'
    mode   '0700'
    action :create
    variables(
        'log':     "#{log_dir}/patch.log",
        'os_fam':  node['platform_family'],
        'os_vers': node['platform_version'].to_i
      )
  end

  # Check if pre patch reboot is required
#  unless tagged?('pre_patch_rebooted')
#    tag('pre_patch_rebooted')
#    execute 'Check if pre_patch reboot is required' do
#      command "echo 'pre patch reboot underway'"
#     notifies :reboot_now, 'reboot[now]', :immediately
#    end
#    return
#  end

  if tagged?('pre_patch_rebooted')
    untag('pre_patch_rebooted')
    untag('do_patch')
    tag("patched_#{Time.new.strftime("%Y-%m-%d")}")

    var_partition_available_size = `df -h /var | sed -n '2p' | awk '{print $4}' | cut -d"G" -f1`

    if var_partition_available_size.to_i > node['linux_patching']['var_partition_min_diskspace_required_in_GB']
      # Run the patching script
      execute 'Patch server' do
        command patch_script
#        notifies :request_reboot, 'reboot[now]', :delayed
      end
    else
      raise 'Can not patch node due to insufficient disk space'
    end

  end

end
