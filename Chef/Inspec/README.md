# Chef Inspec

This documentation provides a guide to Chef InSpec, covering its overview, usage, supported platforms, and installation process.

## Table of Contents

1. [Overview of Chef InSpec](#an-overview-of-chef-inspec)
2. [How Does Chef InSpec Work](#how-does-chef-inspec-work)
3. [Use Cases](#use-cases)
4. [Supported Platform](#supported-platforms)
5. [Install Chef InSpec](#install)
6. [How to Use Chef InSpec](#how-to-use-chef-inspec)
7. [Additional Resources](#additional-resources)

## An Overview of Chef InSpec

Chef InSpec is an open-source framework for writing and executing infrastructure tests. It allows users to define compliance, security, and policy tests as code. Chef InSpec ensures that your infrastructure adheres to the security, compliance, and configuration policies you've established. It supports various platforms and integrates seamlessly with the Chef ecosystem to automate compliance testing across the infrastructure.

Chef InSpec can be used to:

- Checking the security of your systems.
- Ensure that infrastructure remains compliant with industry standards (e.g., CIS Benchmarks, PCI-DSS, HIPAA).
- Automate the testing of system configurations.

## How does Chef InSpec work?

Chef InSpec works by executing compliance and security checks written as human-readable tests. These tests are written using InSpec profiles, which contain a collection of tests and can be customized to match specific organizational policies.

The workflow generally involves:

1. **Write Tests as Code**: Define the desired compliance or configuration state in the form of InSpec profiles and controls.
2. **Execute Tests**: Run InSpec on your infrastructure using a target mode to check whether the systems conform to the specified policies.
3. **Report Results**: Chef InSpec provides detailed reports highlighting any failed tests, allowing you to quickly remediate any compliance issues.
4. **Continuous Monitoring**: With integration into Chef Automate, you can continuously monitor your infrastructure's compliance status.


## Use cases

Chef InSpec is commonly used in several scenarios:

- Compliance Auditing: Automate the validation of your infrastructure against security standards like CIS, NIST, or PCI-DSS.
- Security Testing: Ensure your systems are configured securely with automated security checks.
- Policy Enforcement: Maintain consistency across your infrastructure by defining baseline configurations and ensuring they are followed.
- DevSecOps: Integrate compliance and security checks into your CI/CD pipeline, allowing for early detection and remediation of configuration drift.

## Supported Platforms

Chef InSpec is supported on the following operating systems and platforms:

### Commercially Supported Platforms

| Platform                        | Architecture               | Version                                        |
|----------------------------------|----------------------------|------------------------------------------------|
| **Amazon Linux**                 | x86_64, aarch64             | 2.x                                            |
| **Debian**                       | x86_64, aarch64 (10.x only) | 9, 10, 11                                      |
| **macOS**                        | x86_64, aarch64 (M1)        | 11.x, 12.x                                     |
| **Oracle Enterprise Linux**      | x86_64, aarch64 (7.x / 8.x) | 6.x, 7.x, 8.x                                  |
| **Red Hat Enterprise Linux**     | x86_64, aarch64 (7.x, 8.x, 9.x) | 7.x, 8.x, 9.x                                  |
| **SUSE Linux Enterprise Server** | x86_64, aarch64 (15.x only) | 12.x, 15.x                                     |
| **Ubuntu**                       | x86_64                      | 16.04, 18.04, 20.04                            |
| **Windows**                      | x86_64                      | 8.1, 2012, 2012 R2, 2016, 10 (all channels except "insider" builds), 2019, 11, 2022 |

### Derived Platforms

| Platform         | Architecture    | Version | Parent Platform |
|------------------|-----------------|---------|-----------------|
| **AlmaLinux**    | x86_64, aarch64 | 8.x     | CentOS          |
| **Rocky Linux**  | x86_64, aarch64 | 8.x     | CentOS          |

**Note:** Chef InSpec may function on additional platforms, versions, and architectures in **Target Mode** (`inspec --target`), but they are not officially validated by Chef.


## Install

Because Chef InSpec is already included as part of the Chef Workstation package. If you have Chef Workstation installed, you already have Chef InSpec available for use.

Verify that Chef InSpec is available:
```
inspec --version
```
the output:
```
Chef InSpec version: 5.22.40
```

You should see the installed version of Chef InSpec.

## How to use Chef Inspec

Using Chef InSpec involves writing and running compliance profiles on your systems. Here's how to get started:

### Step 1: Create or Download an InSpec Profile

Create a new InSpec profile using the ``inspec`` command:
```
inspec init profile habitat-inspec
```

the output:
```
[root@chefworkstation inspec]# inspec init profile habitat-inspec

 ─────────────────────────── InSpec Code Generator ───────────────────────────

Creating new profile at /root/inspec/habitat-inspec
 • Creating file README.md
 • Creating directory controls
 • Creating file controls/example.rb
 • Creating file inspec.yml

```

Note:

Chef InSpec has a lot of pre-built profiles, especially for compliance checks (e.g., CIS benchmarks, DevSec hardening).

You can download existing profiles from:
- Chef Supermarket
- GitHub repositories

### Step 2: Write InSpec Control

Once you have a profile, you write controls in the ``controls/`` directory to check for specific configurations. (e.g., in a file named ``habitat_inspec.rb``).

```
# copyright: 2024, The Authors

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
```

### Step 3: Run the InSpec tests

```
inspec exec /path/to/profile --target ssh://user@hostname --password 'password'
```

This approach ensures that all key components from the original Chef Habitat recipe are validated for proper setup and configuration using InSpec.

The output:
```
Profile: InSpec Profile (habitat-setup)
Version: 1.0.0
Target:  ssh://root@192.168.1.10

  ✔  habitat-setup-1.0: Verify Habitat installation and configuration
     ✔  Command hab --version exit_status should eq 0
     ✔  Command hab --version stdout should match /hab \d+\.\d+\.\d+/
     ✔  User hab should exist
     ✔  User hab shell should eq "/bin/bash"
     ✔  User hab system should eq true
     ✔  File /hab/svc/np-mongodb should be directory
     ✔  File /hab/svc/np-mongodb should be owned by "hab"
     ✔  File /hab/svc/np-mongodb should be grouped into "hab"
     ✔  File /hab/svc/np-mongodb mode should cmp == "0755"
     ✔  File /hab/svc/national-parks should be directory
     ✔  File /hab/svc/national-parks should be owned by "hab"
     ✔  File /hab/svc/national-parks should be grouped into "hab"
     ✔  File /hab/svc/national-parks mode should cmp == "0755"
     ✔  File /hab/cache/ssl/automate.cert should exist
     ✔  File /hab/cache/ssl/automate.cert should be owned by "root"
     ✔  File /hab/cache/ssl/automate.cert should be grouped into "root"
     ✔  File /hab/cache/ssl/automate.cert mode should cmp == "0644"
     ✔  Command ping -c 4 bldr.habitat.sh exit_status should eq 0
     ✔  Processes hab-sup states should include "R"
     ✔  Command hab pkg path mwrock/np-mongodb exit_status should eq 0
     ✔  Command hab pkg path mwrock/national-parks exit_status should eq 0
     ✔  Command hab svc status mwrock/np-mongodb exit_status should eq 0
     ✔  Command hab svc status mwrock/np-mongodb stdout should match /up/
     ✔  Command hab svc status mwrock/national-parks exit_status should eq 0
     ✔  Command hab svc status mwrock/national-parks stdout should match /up/
     ✔  Service firewalld should not be running

Profile Summary: 28 successful controls, 0 control failures, 0 controls skipped

```

## Additional Resources

- []()
- []()
