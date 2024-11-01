#
# Cookbook:: habitat_setup
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# Install Habitat
remote_file '/root/install_habitat.sh' do
     source 'https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh'
     mode '0755'
     action :create
   end
   
   execute 'install_habitat' do
     command 'bash /root/install_habitat.sh'
     not_if 'which hab'
end

# Accept Habitat License
execute 'export_hab_license' do
  command 'export HAB_LICENSE="accept"'
  action :run
end
   
   # Verify Habitat installation
   execute 'verify_hab_installation' do
     command 'hab --version'
   end
   
   # Create user 'hab'
   user 'hab' do
     comment 'Habitat User'
     system true
     shell '/bin/bash'
   end
   
   # Create directories and set ownership
   ['/hab/svc/np-mongodb', '/hab/svc/national-parks'].each do |dir|
     directory dir do
       owner 'hab'
       group 'hab'
       mode '0755'
       recursive true
     end
   end
   
   # Copy SSL certificate to /hab/cache/ssl/
   cookbook_file '/hab/cache/ssl/automate.cert' do
     source 'automate.cert'
     owner 'root'
     group 'root'
     mode '0644'
     action :create
   end

   # Ping bldr.habitat.sh to ensure connectivity
   execute 'ping_bldr' do
     command 'ping -c 4 bldr.habitat.sh'
     action :run
   end
   
   # Run Habitat supervisor in the background
   execute 'run_hab_sup' do
     command 'hab sup run & --event-stream-application=national-parks --event-stream-environment=production --event-stream-site=national-site --event-stream-url=automate.chef.lab:4222 --event-stream-token=rHqbbA1WpDQC91KovizzmvqYzPo= --event-stream-server-certificate=/hab/cache/ssl/automate.cert'
     action :run
     not_if 'pgrep hab-sup'
   end
   
   # Install required packages
   ['mwrock/np-mongodb', 'mwrock/national-parks'].each do |pkg|
     execute "install_#{pkg}" do
       command "hab pkg install #{pkg}"
     end
   end
   
   # Load services
   execute 'load_np_mongodb' do
     command 'hab svc load mwrock/np-mongodb'
   end
   
   execute 'load_national_parks' do
     command 'hab svc load mwrock/national-parks --bind database:np-mongodb.default'
   end
   
   # Check service status
   execute 'check_hab_svc_status' do
     command 'hab svc status'
   end
   
   # Stop firewalld service
   service 'firewalld' do
     action :stop
   end
   