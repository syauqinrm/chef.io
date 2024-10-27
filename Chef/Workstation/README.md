# Chef Workstation

This documentation provides a comprehensive guide on setting up and using Chef Workstation. It explains how Chef Workstation serves as the central tool for infrastructure automation by providing all the necessary resources for creating, testing, and deploying infrastructure as code (IaC). The document also covers the workflow for developing cookbooks, configuring the Chef environment, and deploying configurations to nodes.

## Table of Contents

1. [Chef Workstation Overview](#overview)

2. [Chef Workstation Requirements](#chef-workstation-requirements)

3. [Install Chef Workstation](#install)

4. [Setup Chef Workstation](#setup-chef-workstation)

5. [Write Test Cookbooks](#write-a-test-cookbooks)

6. [Bootstrapping to Nodes](#bootstrapping-to-nodes)

7. [Additional Resources](#additional-resources)

## Overview

Chef Workstation is the starting point for automating infrastructure with Chef. It provides system administrators and developers with the necessary tools to author, test, and manage infrastructure as code. Chef Workstation integrates ad-hoc remote execution, configuration tasks, remote scanning, and cookbook creation, combining them with robust dependency management into a single, easy-to-install package. This simplifies the entire workflow of developing and deploying infrastructure automation.

Chef Workstation includes:

- Chef Infra Client
- Chef InSpec
- Chef Habitat
- Chef and Knife command line tools
- Testing tools such as Test Kitchen and Cookstyle
- Everything else needed to author cookbooks and upload them to the Chef Infra Server

### Cookbook Development Workflow

Chef Infra defines a common workflow for cookbook development:

1. Create a skeleton cookbook by running ``chef generate cookbook MY_COOKBOOK_NAME``. This generates a cookbook with a single recipe and testing configuration for Test Kitchen with Chef InSpec.

2. Write cookbook recipes or resources and lint and debug them with Cookstyle and Test Kitchen. Making your own cookbooks is an iterative process where you develop, test, find and fix bugs, and then develop and test some more. A text editor—Visual Studio Code, Atom, vim, or any other preferred text editor—is the only tool that you need to author your cookbooks.

3. Test in acceptance. Test your work in an environment that matches your production environment.

4. Deploy your cookbooks to the production environment, but only after they pass all the acceptance tests and are verified to work in the desired manner.

### Chef Workstation Tools


Chef Workstation packages all the tools necessary to be successful with Chef Infra and InSpec. Below are the important tools included:

| Tool                | Description                                                                                   |
|---------------------|-----------------------------------------------------------------------------------------------|
| Chef CLI            | A workflow tool for Chef Infra.                                                              |
| knife               | A tool for managing systems on the Chef Infra Server.                                        |
| Chef Infra Client   | The Chef Infra agent.                                                                         |
| Chef InSpec         | A compliance as code tool that can also be used for testing Chef Infra cookbooks.            |
| Cookstyle           | A linting tool that helps you write better Chef Infra cookbooks by detecting and correcting style, syntax, and logic mistakes in your code. |
| Test Kitchen        | An integration testing framework tool that tests cookbooks across platforms and various cloud providers/hypervisors. |

## Chef Workstation Requirements

### Supported Platforms



| Platform                           | Architecture          | Version                                                             |
|------------------------------------|---------------------|-------------------------------------------------------------------|
| Amazon Linux                       | x86_64, arch64 (2023 only) | 2.x, 2023                                                         |
| macOS                              | x86_64, arch64      | 12.x                                                              |
| Debian                             | x86_64              | 10.x, 11.x                                                        |
| Red Hat Enterprise Linux / CentOS   | x86_64              | 7.x, 8.x, 9.x                                                     |
| Ubuntu                             | x86_64              | 18.04, 20.04, 22.04                                               |
| Windows                            | x64                 | 10, 11, Server 2012, Server 2012 R2, Server 2016, Server 2019, Server 2022 |

### System Requirements

Minimum system requirements:

- RAM: 4GB (But in this documentation, we only need 1024 or 1536 MB)
- Disk: 8GB
- Additional memory and storage space may be necessary to take advantage of Chef Workstation tools such as Test Kitchen which creates and manages virtualized test environments.

Additional Chef Workstation App Requirements:

- On Linux, you must have a graphical window manager running with support for system tray icons. For some distributions you may also need to install additional libraries. After you install the Chef Workstation package from the terminal, the post-install message will tell you which, if any, additional libraries are required to run the Chef Workstation App.

## Install 

Here’s how to install and configure Chef Wokrstation on RHEL 8.7 (Red Hat Enterprise Linux):

### Step 1: Update The System

Ensure that your system is up to date by running the necessary update commands.

```
dnf update && dnf upgrade -y
```

the output:
```sh
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Last metadata expiration check: 5 days, 23:31:18 ago on Mon 21 Oct 2024 03:19:32 PM WIB.
Dependencies resolved.
Nothing to do.
Complete!
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Last metadata expiration check: 5 days, 23:31:21 ago on Mon 21 Oct 2024 03:19:32 PM WIB.
Dependencies resolved.
Nothing to do.
Complete!
```

After update the system, If you don’t have a valid DNS server in your network, add A record to /etc/hosts file.

```
[root@workstation .chef]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
[root@workstation .chef]# echo "192.168.1.7 infraserver.chef.lab" >> /etc/hosts
[root@workstation .chef]# cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.1.7 infraserver.chef.lab
```

Then install basic standard packages:
```
dnf -y install chrony crontabs git vim nano wget curl bash-completion
```

the output:

```sh
Package chrony-4.2-1.el8.x86_64 is already installed.
Package crontabs-1.11-17.20190603git.el8.noarch is already installed.
Package vim-enhanced-2:8.0.1763-19.el8_6.4.x86_64 is already installed.
Package nano-2.9.8-1.el8.x86_64 is already installed.
Package wget-1.19.5-10.el8.x86_64 is already installed.
Package curl-7.61.1-25.el8.x86_64 is already installed.
Package bash-completion-1:2.7-5.el8.noarch is already installed.
Dependencies resolved.
======================================================================================
 Package                Arch   Version                   Repository              Size
======================================================================================
Installing:
 git                    x86_64 2.31.1-2.el8              InstallMedia-AppStream 161 k
Installing dependencies:
 git-core               x86_64 2.31.1-2.el8              InstallMedia-AppStream 4.7 M
 git-core-doc           noarch 2.31.1-2.el8              InstallMedia-AppStream 2.6 M
 perl-Carp              noarch 1.42-396.el8              InstallMedia-BaseOS     30 k
 perl-Data-Dumper       x86_64 2.167-399.el8             InstallMedia-BaseOS     58 k
 perl-Digest            noarch 1.17-395.el8              InstallMedia-AppStream  27 k
 perl-Digest-MD5        x86_64 2.55-396.el8              InstallMedia-AppStream  37 k
 perl-Encode            x86_64 4:2.97-3.el8              InstallMedia-BaseOS    1.5 M
 perl-Errno             x86_64 1.28-421.el8              InstallMedia-BaseOS     76 k
 perl-Error             noarch 1:0.17025-2.el8           InstallMedia-AppStream  46 k
 perl-Exporter          noarch 5.72-396.el8              InstallMedia-BaseOS     34 k
 perl-File-Path         noarch 2.15-2.el8                InstallMedia-BaseOS     38 k
 perl-File-Temp         noarch 0.230.600-1.el8           InstallMedia-BaseOS     63 k
 perl-Getopt-Long       noarch 1:2.50-4.el8              InstallMedia-BaseOS     63 k
 perl-Git               noarch 2.31.1-2.el8              InstallMedia-AppStream  78 k
 perl-HTTP-Tiny         noarch 0.074-1.el8               InstallMedia-BaseOS     58 k
 perl-IO                x86_64 1.38-421.el8              InstallMedia-BaseOS    142 k
 perl-MIME-Base64       x86_64 3.15-396.el8              InstallMedia-BaseOS     31 k
 perl-Net-SSLeay        x86_64 1.88-2.module+el8.6.0+13392+f0897f98
                                                         InstallMedia-AppStream 379 k
 perl-PathTools         x86_64 3.74-1.el8                InstallMedia-BaseOS     90 k
 perl-Pod-Escapes       noarch 1:1.07-395.el8            InstallMedia-BaseOS     20 k
 perl-Pod-Perldoc       noarch 3.28-396.el8              InstallMedia-BaseOS     88 k
 perl-Pod-Simple        noarch 1:3.35-395.el8            InstallMedia-BaseOS    213 k
 perl-Pod-Usage         noarch 4:1.69-395.el8            InstallMedia-BaseOS     34 k
 perl-Scalar-List-Utils x86_64 3:1.49-2.el8              InstallMedia-BaseOS     68 k
 perl-Socket            x86_64 4:2.027-3.el8             InstallMedia-BaseOS     59 k
 perl-Storable          x86_64 1:3.11-3.el8              InstallMedia-BaseOS     98 k
 perl-Term-ANSIColor    noarch 4.06-396.el8              InstallMedia-BaseOS     46 k
 perl-Term-Cap          noarch 1.17-395.el8              InstallMedia-BaseOS     23 k
 perl-TermReadKey       x86_64 2.37-7.el8                InstallMedia-AppStream  40 k
 perl-Text-ParseWords   noarch 3.30-395.el8              InstallMedia-BaseOS     18 k
 perl-Text-Tabs+Wrap    noarch 2013.0523-395.el8         InstallMedia-BaseOS     24 k
 perl-Time-Local        noarch 1:1.280-1.el8             InstallMedia-BaseOS     34 k
 perl-URI               noarch 1.73-3.el8                InstallMedia-AppStream 116 k
 perl-Unicode-Normalize x86_64 1.25-396.el8              InstallMedia-BaseOS     82 k
 perl-constant          noarch 1.33-396.el8              InstallMedia-BaseOS     25 k
 perl-interpreter       x86_64 4:5.26.3-421.el8          InstallMedia-BaseOS    6.3 M
 perl-libnet            noarch 3.11-3.el8                InstallMedia-AppStream 121 k
 perl-libs              x86_64 4:5.26.3-421.el8          InstallMedia-BaseOS    1.6 M
 perl-macros            x86_64 4:5.26.3-421.el8          InstallMedia-BaseOS     72 k
 perl-parent            noarch 1:0.237-1.el8             InstallMedia-BaseOS     20 k
 perl-podlators         noarch 4.11-1.el8                InstallMedia-BaseOS    118 k
 perl-threads           x86_64 1:2.21-2.el8              InstallMedia-BaseOS     61 k
 perl-threads-shared    x86_64 1.58-2.el8                InstallMedia-BaseOS     48 k
Installing weak dependencies:
 perl-IO-Socket-IP      noarch 0.39-5.el8                InstallMedia-AppStream  47 k
 perl-IO-Socket-SSL     noarch 2.066-4.module+el8.3.0+6446+594cad75
                                                         InstallMedia-AppStream 298 k
 perl-Mozilla-CA        noarch 20160104-7.module+el8.3.0+6498+9eecfe51
                                                         InstallMedia-AppStream  15 k
Enabling module streams:
 perl                          5.26
 perl-IO-Socket-SSL            2.066
 perl-libwww-perl              6.34

Transaction Summary
======================================================================================
Install  47 Packages

Total size: 20 M
Installed size: 73 M
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                              1/1
  Installing       : perl-Digest-1.17-395.el8.noarch                             1/47
  Installing       : perl-Digest-MD5-2.55-396.el8.x86_64                         2/47
  Installing       : perl-Data-Dumper-2.167-399.el8.x86_64                       3/47
  Installing       : perl-libnet-3.11-3.el8.noarch                               4/47
  Installing       : perl-Net-SSLeay-1.88-2.module+el8.6.0+13392+f0897f98.x86    5/47
  Installing       : perl-URI-1.73-3.el8.noarch                                  6/47
  Installing       : perl-Pod-Escapes-1:1.07-395.el8.noarch                      7/47
  Installing       : perl-Time-Local-1:1.280-1.el8.noarch                        8/47
  Installing       : perl-IO-Socket-IP-0.39-5.el8.noarch                         9/47
  Installing       : perl-Mozilla-CA-20160104-7.module+el8.3.0+6498+9eecfe51.   10/47
  Installing       : perl-IO-Socket-SSL-2.066-4.module+el8.3.0+6446+594cad75.   11/47
  Installing       : perl-Term-ANSIColor-4.06-396.el8.noarch                    12/47
  Installing       : perl-Term-Cap-1.17-395.el8.noarch                          13/47
  Installing       : perl-File-Temp-0.230.600-1.el8.noarch                      14/47
  Installing       : perl-Pod-Simple-1:3.35-395.el8.noarch                      15/47
  Installing       : perl-HTTP-Tiny-0.074-1.el8.noarch                          16/47
  Installing       : perl-podlators-4.11-1.el8.noarch                           17/47
  Installing       : perl-Pod-Perldoc-3.28-396.el8.noarch                       18/47
  Installing       : perl-Text-ParseWords-3.30-395.el8.noarch                   19/47
  Installing       : perl-Pod-Usage-4:1.69-395.el8.noarch                       20/47
  Installing       : perl-MIME-Base64-3.15-396.el8.x86_64                       21/47
  Installing       : perl-Storable-1:3.11-3.el8.x86_64                          22/47
  Installing       : perl-Getopt-Long-1:2.50-4.el8.noarch                       23/47
  Installing       : perl-Errno-1.28-421.el8.x86_64                             24/47
  Installing       : perl-Socket-4:2.027-3.el8.x86_64                           25/47
  Installing       : perl-Encode-4:2.97-3.el8.x86_64                            26/47
  Installing       : perl-Exporter-5.72-396.el8.noarch                          27/47
  Installing       : perl-Scalar-List-Utils-3:1.49-2.el8.x86_64                 28/47
  Installing       : perl-macros-4:5.26.3-421.el8.x86_64                        29/47
  Installing       : perl-parent-1:0.237-1.el8.noarch                           30/47
  Installing       : perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch               31/47
  Installing       : perl-Unicode-Normalize-1.25-396.el8.x86_64                 32/47
  Installing       : perl-File-Path-2.15-2.el8.noarch                           33/47
  Installing       : perl-IO-1.38-421.el8.x86_64                                34/47
  Installing       : perl-PathTools-3.74-1.el8.x86_64                           35/47
  Installing       : perl-constant-1.33-396.el8.noarch                          36/47
  Installing       : perl-threads-1:2.21-2.el8.x86_64                           37/47
  Installing       : perl-threads-shared-1.58-2.el8.x86_64                      38/47
  Installing       : perl-libs-4:5.26.3-421.el8.x86_64                          39/47
  Installing       : perl-Carp-1.42-396.el8.noarch                              40/47
  Installing       : perl-interpreter-4:5.26.3-421.el8.x86_64                   41/47
  Installing       : git-core-2.31.1-2.el8.x86_64                               42/47
  Installing       : git-core-doc-2.31.1-2.el8.noarch                           43/47
  Installing       : perl-Error-1:0.17025-2.el8.noarch                          44/47
  Installing       : perl-TermReadKey-2.37-7.el8.x86_64                         45/47
  Installing       : perl-Git-2.31.1-2.el8.noarch                               46/47
  Installing       : git-2.31.1-2.el8.x86_64                                    47/47
  Running scriptlet: git-2.31.1-2.el8.x86_64                                    47/47
  Verifying        : perl-Carp-1.42-396.el8.noarch                               1/47
  Verifying        : perl-Data-Dumper-2.167-399.el8.x86_64                       2/47
  Verifying        : perl-Encode-4:2.97-3.el8.x86_64                             3/47
  Verifying        : perl-Errno-1.28-421.el8.x86_64                              4/47
  Verifying        : perl-Exporter-5.72-396.el8.noarch                           5/47
  Verifying        : perl-File-Path-2.15-2.el8.noarch                            6/47
  Verifying        : perl-File-Temp-0.230.600-1.el8.noarch                       7/47
  Verifying        : perl-Getopt-Long-1:2.50-4.el8.noarch                        8/47
  Verifying        : perl-HTTP-Tiny-0.074-1.el8.noarch                           9/47
  Verifying        : perl-IO-1.38-421.el8.x86_64                                10/47
  Verifying        : perl-MIME-Base64-3.15-396.el8.x86_64                       11/47
  Verifying        : perl-PathTools-3.74-1.el8.x86_64                           12/47
  Verifying        : perl-Pod-Escapes-1:1.07-395.el8.noarch                     13/47
  Verifying        : perl-Pod-Perldoc-3.28-396.el8.noarch                       14/47
  Verifying        : perl-Pod-Simple-1:3.35-395.el8.noarch                      15/47
  Verifying        : perl-Pod-Usage-4:1.69-395.el8.noarch                       16/47
  Verifying        : perl-Scalar-List-Utils-3:1.49-2.el8.x86_64                 17/47
  Verifying        : perl-Socket-4:2.027-3.el8.x86_64                           18/47
  Verifying        : perl-Storable-1:3.11-3.el8.x86_64                          19/47
  Verifying        : perl-Term-ANSIColor-4.06-396.el8.noarch                    20/47
  Verifying        : perl-Term-Cap-1.17-395.el8.noarch                          21/47
  Verifying        : perl-Text-ParseWords-3.30-395.el8.noarch                   22/47
  Verifying        : perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch               23/47
  Verifying        : perl-Time-Local-1:1.280-1.el8.noarch                       24/47
  Verifying        : perl-Unicode-Normalize-1.25-396.el8.x86_64                 25/47
  Verifying        : perl-constant-1.33-396.el8.noarch                          26/47
  Verifying        : perl-interpreter-4:5.26.3-421.el8.x86_64                   27/47
  Verifying        : perl-libs-4:5.26.3-421.el8.x86_64                          28/47
  Verifying        : perl-macros-4:5.26.3-421.el8.x86_64                        29/47
  Verifying        : perl-parent-1:0.237-1.el8.noarch                           30/47
  Verifying        : perl-podlators-4.11-1.el8.noarch                           31/47
  Verifying        : perl-threads-1:2.21-2.el8.x86_64                           32/47
  Verifying        : perl-threads-shared-1.58-2.el8.x86_64                      33/47
  Verifying        : git-2.31.1-2.el8.x86_64                                    34/47
  Verifying        : git-core-2.31.1-2.el8.x86_64                               35/47
  Verifying        : git-core-doc-2.31.1-2.el8.noarch                           36/47
  Verifying        : perl-Digest-1.17-395.el8.noarch                            37/47
  Verifying        : perl-Digest-MD5-2.55-396.el8.x86_64                        38/47
  Verifying        : perl-Error-1:0.17025-2.el8.noarch                          39/47
  Verifying        : perl-Git-2.31.1-2.el8.noarch                               40/47
  Verifying        : perl-IO-Socket-IP-0.39-5.el8.noarch                        41/47
  Verifying        : perl-IO-Socket-SSL-2.066-4.module+el8.3.0+6446+594cad75.   42/47
  Verifying        : perl-Mozilla-CA-20160104-7.module+el8.3.0+6498+9eecfe51.   43/47
  Verifying        : perl-Net-SSLeay-1.88-2.module+el8.6.0+13392+f0897f98.x86   44/47
  Verifying        : perl-TermReadKey-2.37-7.el8.x86_64                         45/47
  Verifying        : perl-URI-1.73-3.el8.noarch                                 46/47
  Verifying        : perl-libnet-3.11-3.el8.noarch                              47/47
Installed products updated.

Installed:
  git-2.31.1-2.el8.x86_64
  git-core-2.31.1-2.el8.x86_64
  git-core-doc-2.31.1-2.el8.noarch
  perl-Carp-1.42-396.el8.noarch
  perl-Data-Dumper-2.167-399.el8.x86_64
  perl-Digest-1.17-395.el8.noarch
  perl-Digest-MD5-2.55-396.el8.x86_64
  perl-Encode-4:2.97-3.el8.x86_64
  perl-Errno-1.28-421.el8.x86_64
  perl-Error-1:0.17025-2.el8.noarch
  perl-Exporter-5.72-396.el8.noarch
  perl-File-Path-2.15-2.el8.noarch
  perl-File-Temp-0.230.600-1.el8.noarch
  perl-Getopt-Long-1:2.50-4.el8.noarch
  perl-Git-2.31.1-2.el8.noarch
  perl-HTTP-Tiny-0.074-1.el8.noarch
  perl-IO-1.38-421.el8.x86_64
  perl-IO-Socket-IP-0.39-5.el8.noarch
  perl-IO-Socket-SSL-2.066-4.module+el8.3.0+6446+594cad75.noarch
  perl-MIME-Base64-3.15-396.el8.x86_64
  perl-Mozilla-CA-20160104-7.module+el8.3.0+6498+9eecfe51.noarch
  perl-Net-SSLeay-1.88-2.module+el8.6.0+13392+f0897f98.x86_64
  perl-PathTools-3.74-1.el8.x86_64
  perl-Pod-Escapes-1:1.07-395.el8.noarch
  perl-Pod-Perldoc-3.28-396.el8.noarch
  perl-Pod-Simple-1:3.35-395.el8.noarch
  perl-Pod-Usage-4:1.69-395.el8.noarch
  perl-Scalar-List-Utils-3:1.49-2.el8.x86_64
  perl-Socket-4:2.027-3.el8.x86_64
  perl-Storable-1:3.11-3.el8.x86_64
  perl-Term-ANSIColor-4.06-396.el8.noarch
  perl-Term-Cap-1.17-395.el8.noarch
  perl-TermReadKey-2.37-7.el8.x86_64
  perl-Text-ParseWords-3.30-395.el8.noarch
  perl-Text-Tabs+Wrap-2013.0523-395.el8.noarch
  perl-Time-Local-1:1.280-1.el8.noarch
  perl-URI-1.73-3.el8.noarch
  perl-Unicode-Normalize-1.25-396.el8.x86_64
  perl-constant-1.33-396.el8.noarch
  perl-interpreter-4:5.26.3-421.el8.x86_64
  perl-libnet-3.11-3.el8.noarch
  perl-libs-4:5.26.3-421.el8.x86_64
  perl-macros-4:5.26.3-421.el8.x86_64
  perl-parent-1:0.237-1.el8.noarch
  perl-podlators-4.11-1.el8.noarch
  perl-threads-1:2.21-2.el8.x86_64
  perl-threads-shared-1.58-2.el8.x86_64

Complete!
```

### Step 2: Configure NTP

Ensure that Network Time Protocol (NTP) is properly configured to synchronize time across systems.

```
service chronyd start
```

The service status should show running.

```sh
[root@workstation ~]# systemctl status chronyd
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: e>
   Active: active (running) since Sun 2024-10-27 16:28:15 WIB; 3h 39min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 4694 ExecStopPost=/usr/libexec/chrony-helper remove-daemon-state (code=exi>
  Process: 4704 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, >
  Process: 4698 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 4702 (chronyd)
    Tasks: 1 (limit: 5922)
   Memory: 936.0K
   CGroup: /system.slice/chronyd.service
           └─4702 /usr/sbin/chronyd

Oct 27 16:28:15 workstation.chef.lab systemd[1]: Starting NTP client/server...
Oct 27 16:28:15 workstation.chef.lab chronyd[4702]: chronyd version 4.2 starting (+CM>
Oct 27 16:28:15 workstation.chef.lab chronyd[4702]: Frequency -9.267 +/- 0.334 ppm re>
Oct 27 16:28:15 workstation.chef.lab chronyd[4702]: Using right/UTC timezone to obtai>
Oct 27 16:28:15 workstation.chef.lab systemd[1]: Started NTP client/server.
Oct 27 16:28:20 workstation.chef.lab chronyd[4702]: Selected source 14.102.153.110 (2>
Oct 27 16:28:20 workstation.chef.lab chronyd[4702]: System clock wrong by 13024.02827>
Oct 27 20:05:24 workstation.chef.lab chronyd[4702]: System clock was stepped by 13024>
Oct 27 20:05:24 workstation.chef.lab chronyd[4702]: System clock TAI offset set to 37>
Oct 27 20:06:31 workstation.chef.lab chronyd[4702]: Source 203.89.31.13 replaced with>
```

### Step 4: Download and Install Chef Workstation

Install Chef Workstation on RHEL 8 by downloading the latest release on Chef Workstation releases page.

```
wget https://packages.chef.io/files/stable/chef-workstation/24.4.1064/el/8/chef-workstation-24.4.1064-1.el8.x86_64.rpm
```

After the download, install Chef Workstation RHEL 8:

```
dnf localinstall chef-workstation-24.4.1064-1.el8.x86_64.rpm
```

Accept installation by pressing the y key when asked.
```sh
Dependencies resolved.
======================================================================================
 Package                Architecture Version                 Repository          Size
======================================================================================
Installing:
 chef-workstation       x86_64       24.4.1064-1.el8         @commandline       220 M

Transaction Summary
======================================================================================
Install  1 Package

Total size: 220 M
Installed size: 1.1 G
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                              1/1
  Running scriptlet: chef-workstation-24.4.1064-1.el8.x86_64                      1/1
  Installing       : chef-workstation-24.4.1064-1.el8.x86_64                      1/1
  Running scriptlet: chef-workstation-24.4.1064-1.el8.x86_64                      1/1

Chef Workstation ships with a toolbar application, the Chef Workstation App.
To run this application some additional dependencies must be installed.
Using your platform's package manager to install the 'electron' package is
the easiest way to meet the dependency requirements.
```

Ensure that you can access Chef Workstation from the command line by running the command below to verify the version:
```sh
[root@workstation ~]# chef --version

Chef Workstation version: 24.4.1064
Test Kitchen version: 3.6.0
Cookstyle version: 7.32.8
Chef Infra Client version: 18.4.12
Chef InSpec version: 5.22.40
Chef CLI version: 5.6.14
Chef Habitat version: 1.6.652
```

Knife should be installed as well.

## Setup Chef Workstation

### Step 1: Configure Ruby Environment

For many users, Ruby is primarily used for developing Chef policy (for example, cookbooks, Policyfiles, and Chef InSpec profiles). If that’s true for you, then we recommend using the Chef Workstation Ruby as your default system Ruby. If you use Ruby for software development, you’ll want to skip this step.

1. Determine your default shell by running:
```
[root@workstation ~]# echo $SHELL
/bin/bash
```
This will give you the path to your default shell such as ``/bin/bash`` for the Bash shell.

2. Add the Workstation initialization content to the appropriate shell rc file:

For Bash shells run:
```
echo 'eval "$(chef shell-init bash)"' >> ~/.bashrc
```

3. Open a new shell window and run:
```
which ruby
```

The command should return /opt/chef-workstation/embedded/bin/ruby.


### Step 2: Generate Chef repositories 

The chef-repo is a directory on your workstation that stores everything you need to define your infrastructure with Chef Infra:

- Cookbooks (including recipes, attributes, custom resources, libraries, and templates)
- Data bags
- Policyfiles

The chef-repo directory should be synchronized with a version control system, such as git. All of the data in the chef-repo should be treated like source code.

Use the ``chef generate repo REPO-NAME`` command to create your Chef Infra repository. For example, to create a repository called ``chef-repo``:
```
chef generate repo chef-repo
```

Accept installation by pressing the y key when asked.
```sh
+---------------------------------------------+
            Chef License Acceptance

Before you can continue, 3 product licenses
must be accepted. View the license at
https://www.chef.io/end-user-license-agreement/

Licenses that need accepting:
  * Chef Workstation
  * Chef Infra Client
  * Chef InSpec

Do you accept the 3 product licenses (yes/no)?

> yes

Persisting 3 product licenses...
✔ 3 product licenses persisted.

+---------------------------------------------+
Generating Chef Infra repo chef-repo
- Ensuring correct Chef Infra repo file content

Your new Chef Infra repo is ready! Type `cd chef-repo` to enter it.
```

The chef repo directory should have.
```sh
[root@workstation ~]# tree chef-repo/
chef-repo/
├── chefignore
├── cookbooks
│   ├── example
│   │   ├── attributes
│   │   │   └── default.rb
│   │   ├── metadata.rb
│   │   ├── README.md
│   │   └── recipes
│   │       └── default.rb
│   └── README.md
├── data_bags
│   ├── example
│   │   └── example_item.json
│   └── README.md
├── LICENSE
├── policyfiles
│   └── README.md
└── README.md

7 directories, 11 files
```

### Step 3: Configure Your User Credentials File

Create a ``.chef`` directory inside the chef-repo directory.
```
cd chef-repo
mkdir .chef
cd .chef
```

The .chef directory should contain two files:

- Your knife configuration file, knife.rb
- Your RSA private key

Download your RSA Private key from the Chef Server – This was generated during the installation of Chef server.

```
[root@workstation .chef]# scp infraserver.chef.lab:/root/chefadmin.pem .
chefadmin.pem                                       100% 1674   137.7KB/s   00:00
```

Replace ``infraserver.chef.lab`` with your Chef Server address, and /root/chefadmin.pem with the location of your Private Key.

You can also use Organization Validator, but first download validator Private Key.
```
[root@workstation .chef]# scp infraserver.chef.lab:/root/lab-validator.pem .
root@infraserver.chef.lab's password:
lab-validator.pem                                   100% 1678   125.5KB/s   00:00
[root@workstation .chef]# ls
chefadmin.pem  lab-validator.pem
```

Create a knife.rb file.
```
touch knife.rb
```

Then configure knife's file to:
```sh
current_dir = File.dirname(__FILE__)
log_level                :info
ssl_verify_mode          :verify_none
log_location             STDOUT
node_name                'chefadmin'
validation_client_name   'lab-validator'
client_key               "#{current_dir}/chefadmin.pem"
validation_key           "#{current_dir}/lab-validator.pem"
chef_server_url          "https://infraserver.chef.lab/organizations/lab"
cookbook_path            ["#{current_dir}/../cookbooks"]
```


### Step 4: Fetch Self Signed Certificates

If the Chef Infra Server you’re configured to use has a self signed certificate, you’ll use the knife ssl fetch subcommand to download the Chef Infra Server TLS/SSL certificate and save it in your .chef/trusted_certs.

Chef Infra verifies the security of all requests made to the server from tools such a knife and Chef Infra Client. The certificate that is generated during the installation of the Chef Infra Server is self-signed, which means there isn’t a signing certificate authority (CA) to verify. In addition, this certificate must be downloaded to any machine from which knife and/or Chef Infra Client will make requests to the Chef Infra Server.

Use the knife ssl fetch subcommand to pull the SSL certificate down from the Chef Infra Server:

```
knife ssl fetch
```

Validate the downloaded SSL certificate:
```sh
[root@workstation .chef]# knife ssl check
Connecting to host infraserver.chef.lab:443
Successfully verified certificates from `infraserver.chef.lab'
[root@workstation .chef]# file trusted_certs/infraserver_chef_lab.crt
trusted_certs/infraserver_chef_lab.crt: PEM certificate
```

Confirm that knife.rb is set up correctly by running the client list:
```
[root@workstation chef-repo]# knife client list
lab-validator
```

This command should output the validator name.

## Write a test Cookbooks

In this section, we will create a simple Chef cookbook to create three users on a system: ``testuser with UID 2022``, ``testchef with UID 2010``, and ``masterchef with UID 2030``.

### Step 1: Generate cookbook

Generate a cookbook using the command syntax:

``chef generate cookbook COOKBOOK_PATH/COOKBOOK_NAME (options)``

As an example, let’s name our cookbook ``user_management``

```sh
[root@workstation chef-repo]# chef generate cookbook cookbooks/user_management
Generating cookbook user_management
- Ensuring correct cookbook content

Your cookbook is ready. Type `cd cookbooks/user_management` to enter it.

There are several commands you can run to get started locally developing and testing your cookbook.

Why not start by writing an InSpec test? Tests for the default recipe are stored at:

test/integration/default/default_test.rb

If you'd prefer to dive right in, the default recipe can be found at:

recipes/default.rb

[root@workstation chef-repo]# tree cookbooks/user_management/
cookbooks/user_management/
├── CHANGELOG.md
├── chefignore
├── compliance
│   ├── inputs
│   ├── profiles
│   ├── README.md
│   └── waivers
├── kitchen.yml
├── LICENSE
├── metadata.rb
├── Policyfile.rb
├── README.md
├── recipes
│   └── default.rb
└── test
    └── integration
        └── default
            └── default_test.rb

8 directories, 10 files
```

### Step 2: Create Recipes

Now create an User Management recipe which has resource definitions to:

create three users on a system: ``testuser with UID 2022``, ``testchef with UID 2010``, and ``masterchef with UID 2030``.

Edit the ``default.rb`` file to add the user creation logic as shown below:

```
[root@workstation chef-repo]# cd cookbooks/user_management/
[root@workstation user_management]# nano recipes/default.rb
```

```
#
# Cookbook:: user_management
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

# Create user 'testuser' with UID 2022
user 'testuser' do 
  uid 2022 
  comment 'User testuser' 
  home '/home/testuser'
  shell '/bin/bash' 
  manage_home true
end

# Create user 'testchef' with UID 2010
user 'testchef' do 
  uid 2010 
  comment 'User testchef' 
  home '/home/testchef'
  shell '/bin/bash' 
  manage_home true
end

# Create user 'masterchef' with UID 2030
user 'masterchef' do 
  uid 2030 
  comment 'User masterchef' 
  home '/home/masterchef' 
  shell '/bin/bash' 
  manage_home true
end
```

### Step 3: Upload Cookbook to Chef Infra Server

We have our test cookbook ready to be uploaded to Chef Server.

```
[root@workstation chef-repo]# knife cookbook upload user_management
Uploading user_management [0.1.0]
Uploaded 1 cookbook.
```

Confirm by listing cookbooks on the Chef Server
```
[root@workstation chef-repo]# knife cookbook list
user_management   0.1.0
```

## Bootstrapping to Nodes

The knife bootstrap is the command you use to bootstrap a node. When using this command, you specify arguments depending on how you would normally connect to your node over SSH.
You can connect to the Node via:

- Key-based authentication
- Password authentication

Key-based authentication is typically recommended over password authentication because it is more secure, but you can bootstrap your node using either method. In either method, the --node-name argument uniquely identifies the node with the Chef server and its value can be whatever you want.

### Step 1: Create a SSH keygen 

```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```

### Step 2: Copy SSH id_rsa.pub to Client/Node

```
ssh-copy-id -i ~/.ssh/id_rsa.pub root@<IP_node/client>
```

### Step 3: Bootstrapping to Node

```
knife bootstrap <IP-client> -x root --ssh-identity-file /root/.ssh/id_rsa -N <namanode> -r 'recipe[namaresep]'
```

Knife Node Bootstrap will:

- Login to node
- Install chef-client
- Configure chef-client
- Run chef-client

Sample output:

```sh
[192.168.1.10] Starting Chef Infra Client, version 24.4.1064
Patents: https://www.chef.io/patents
 [192.168.1.10] resolving cookbooks for run list: ["user_management"]
 [192.168.1.10] Synchronizing Cookbooks:
 [192.168.1.10]   - user_management (0.1.0)
 [192.168.1.10] Installing Cookbook Gems:
Compiling Cookbooks...
 [192.168.1.10] Converging 3 resources
Recipe: user_management::default
  * linux_user[testuser] action create
 [192.168.1.10] 
    - create user testuser
  * linux_user[testchef] action create
 [192.168.1.10] 
    - create user testchef
  * linux_user[masterchef] action create
 [192.168.1.10] 
    - create user masterchef
 [192.168.1.10] 
Running handlers:
Running handlers complete
```

To confirm the result, check if your node was associated with your Chef server.

```
[root@workstation chef-repo]# knife node list
cheflocal
```

You can use the commandknife node show to view data about your node.
```
[root@workstation chef-repo]# knife node show cheflocal
Node Name:   cheflocal
Environment: _default
FQDN:        localhost
IP:          192.168.1.10
Run List:    recipe[user_management]
Roles:       
Recipes:     user_management, user_management::default
Platform:    redhat 8.7
Tags:        
```

Open the file /etc/passwdusing command cat on Node to see if our user_management is working
```
[user@localhost ~]# cat /etc/passwd | awk -F: '$3 > 2000'
testuser:x:2022:2022:User testuser:/home/testuser:/bin/bash
testchef:x:2010:2010:User testchef:/home/testchef:/bin/bash
masterchef:x:2030:2030:User masterchef:/home/masterchef:/bin/bash
```

This confirms that your Chef Node can successfully communicate with the Chef Server.

## Additional Resources

- []()
- []()
- []()