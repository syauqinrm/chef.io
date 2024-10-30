# copyright: 2024, Bajau Escorindo

control 'habitat-setup-1.0' do
  title 'Verify Habitat installation and configuration'

  # Verify Habitat installation
  describe command('hab --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/hab \d+\.\d+\.\d+/) }  # Verify habitat version output
  end

  # Check if the 'hab' user exists
  describe user('hab') do
    it { should exist }
    its('shell') { should eq '/bin/bash' }
    its('system') { should eq true }
  end

  # Check if the directories exist and are owned by 'hab'
  ['/hab/svc/np-mongodb', '/hab/svc/national-parks'].each do |dir|
    describe file(dir) do
      it { should be_directory }
      it { should be_owned_by 'hab' }
      it { should be_grouped_into 'hab' }
      its('mode') { should cmp '0755' }
    end
  end

  # Check if the SSL certificate exists and has the correct permissions
  describe file('/hab/cache/ssl/automate.cert') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
  end

  # Ping bldr.habitat.sh to ensure connectivity
  describe command('ping -c 4 bldr.habitat.sh') do
    its('exit_status') { should eq 0 }
  end

  # Check if Habitat supervisor is running
  describe processes('hab-sup') do
    its('states') { should include 'R' } # R: running state
  end

  # Verify that the required Habitat packages are installed
  ['mwrock/np-mongodb', 'mwrock/national-parks'].each do |pkg|
    describe command("hab pkg path #{pkg}") do
      its('exit_status') { should eq 0 }  # pkg should be installed
    end
  end

  # Check if the services are loaded and running
  describe command('hab svc status mwrock/np-mongodb') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/up/) }
  end

  describe command('hab svc status mwrock/national-parks') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match(/up/) }
  end

  # Ensure firewalld is stopped
  describe service('firewalld') do
    it { should_not be_running }
  end
end

