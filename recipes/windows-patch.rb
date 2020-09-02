
windows_updates = [
    { kb: 'KB2267602', source: '' },
    { kb: 'KB4571694', source: 'http://download.windowsupdate.com/d/msdownload/update/software/secu/2020/08/windows10.0-kb4571694-x64_220af1e3a18ef36cb4abe3d34a3ce15ce656753b.msu'}
]

windows_updates.each do |windows_update|
msu_package windows_update[:kb] do
  source windows_update[:source]
  action :install
  notifies :request_reboot, 'reboot[request_reboot]', :delayed
end
end

reboot 'request_reboot' do
   action :nothing
   reason 'Need to reboot when the updates applied.'
end