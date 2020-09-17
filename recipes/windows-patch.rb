if tagged?('do_patch')

windows_updates = node['windows']['updates']

windows_updates.each do |windows_update|
  msu_package windows_update['kb'] do
    source windows_update['source']
    action :install
    notifies :request_reboot, 'reboot[request_reboot]', :delayed
  end
end

untag('do_patch')

reboot 'request_reboot' do
   action :nothing
   reason 'Need to reboot when the updates applied.'
end

end
