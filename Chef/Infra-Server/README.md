# Chef Infra Server

This documentation explains the Chef Infra Server, its installation, configuration, and management. Chef Infra Server is a crucial component in managing infrastructure as code, ensuring consistency, compliance, and efficiency in IT operations.

## Table of Contents

1. [Chef Infra Server Overview](#overview)

2. [Chef Infra Server Prerequisites](#chef-infra-server-prerequisites)

3. [Installation and Configuration](#installation-and-configuration)

4. [Additional Resources](#additional-resources)

## Overview

Chef Infra is a powerful configuration management tool that automates the process of provisioning, configuring, and managing infrastructure. It transforms infrastructure into code, allowing system administrators and developers to define the desired state of their systems and automate the process of ensuring consistency across environments. Whether your infrastructure is on-premises, in the cloud, or in a hybrid environment, Chef Infra helps maintain consistency and reliability by enforcing infrastructure policies through continuous automation.

Chef Infra works by applying a set of configuration instructions, known as ``cookbooks`` and ``recipes``, to each managed node in your infrastructure. These cookbooks define how a system should be configured, from software installations to service management and system settings. The Chef Infra Client, installed on every managed node, regularly checks in with the Chef Infra Server to retrieve the latest configuration changes and applies them if necessary, ensuring the nodes converge to the desired state.

Chef Infra provides scalability and flexibility, allowing organizations to manage thousands of servers effortlessly. It ensures that infrastructure remains compliant with business policies and security standards by continuously monitoring and enforcing the defined configurations. By integrating Chef Infra into your infrastructure management workflow, you can reduce human error, speed up deployments, and ensure a high level of operational efficiency.

The Chef Infra Server is the core component of Chef's infrastructure automation framework, acting as the central hub for managing configurations across all systems within your infrastructure. It stores critical data, including cookbooks, policies, roles, and environments, and serves as the primary source of truth for configuration management. By centralizing the management of infrastructure as code, the Chef Infra Server ensures that all connected nodes (servers) are provisioned, configured, and maintained according to predefined policies, whether on-premises, in the cloud, or in hybrid environments.

Chef Infra Server works in conjunction with Chef Infra Clients installed on managed nodes. The server continuously communicates with these clients, distributing configuration data, retrieving node information, and ensuring that each node's state aligns with the desired configurations. Clients regularly connect to the Chef Infra Server to pull the latest changes in cookbooks and policies and apply them, ensuring consistency and compliance. This process facilitates automated and reliable management of thousands of nodes, maintaining uniformity, reducing human errors, and meeting business and security requirements through continuous enforcement of infrastructure policies.

### Infra Server Components

The Chef Infra Server consists of several core components that work together to store, manage, and distribute configuration data across your infrastructure. Each component has a specific role, ensuring that configuration changes are applied consistently and securely to all nodes under management. Below is a breakdown of the key components within the Chef Infra Server architecture:

| Component         | Description                                                                                                                                                                                                 |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Clients**       | The Chef Infra Server is accessed by nodes managed by Chef Infra Client during client runs. It is also accessed by users maintaining cookbooks and policies, typically from workstations, and by authenticated users. |
| **Load Balancer** | Nginx is used as the front-end load balancer for the Chef Infra Server. It routes all requests to the Chef Infra Server API through Nginx, providing HTTP and reverse proxy services.                         |
| **Chef Manage**   | The web interface for Chef Infra Server, Chef Manage, communicates with the Chef Infra Server using the Chef Infra Server API.                                                                                |
| **Chef Infra Server** | Erchef is the core API for the Chef Infra Server, written in Erlang for improved scalability and performance. It is compatible with the original Ruby-based server, so existing cookbooks and recipes remain functional.|
| **Bookshelf**     | Bookshelf stores cookbook content—files, templates, and more—uploaded to Chef Infra Server as part of a cookbook version. It uses checksums to store files only once, even across different versions or cookbooks.|
| **Messages**      | chef-elasticsearch wraps Elasticsearch, exposing its REST API for indexing and search, storing messages in a dedicated search index repository.                                                               |
| **PostgreSQL**    | PostgreSQL serves as the primary data storage repository for the Chef Infra Server.                                                                                                                           |

## Chef Infra Server Prerequisites

### Supported Platforms for Chef Infra Server

The following table lists the commercially supported platforms for Chef Infra Server:

| Platform                         | Architecture | Version            |
|----------------------------------|--------------|--------------------|
| Amazon Linux                     | x86_64       | 2, 2023            |
| **Red Hat Enterprise Linux**     | x86_64       | 8.x, 9.x           |
| Rocky Linux                      | x86_64       | 9.x                |
| SUSE Linux Enterprise Server     | x86_64       | 12.x, 15.x         |
| Ubuntu                           | x86_64       | 20.04, 22.04       |

- **RHEL 8.7** on VM with specification systems:

1. Processors 1 Core 
2. RAM 2 GB
3. Storage 25 GB
3. Internet Connection

Before installing Chef Infra Server, ensure that the following requirements are met:

- **Hostnames**: Each system must have a fully qualified domain name (FQDN), be resolvable, and contain fewer than 64 characters.

- **NTP (Network Time Protocol)**: Ensure every server is connected to an NTP server to prevent clock drift.

- **Mail Relay** : Configure a local mail transfer agent to allow Chef Infra Server to send notifications.

- **Firewalls and Ports**: Open ports 80 (HTTP) and 443 (HTTPS) for communication.
Git: Install Git, as it is required by internal Chef services.

- **Cron**: Ensure cron is configured to allow periodic maintenance tasks.

Additionally:

- **Browser** — Firefox, Google Chrome, Safari, or Internet Explorer (versions 9 or better)
Chef Infra Client communication with the Chef Infra Server The Chef Infra Server must be able to communicate with every node that will be configured by Chef Infra Client and every workstation that will upload data to the Chef Infra.

## Installation and Configuration

Here’s how to install and configure Chef Infra Server on RHEL 8.7 (Red Hat Enterprise Linux):

### Step 1: Update The System 

```
dnf update -y && dnf upgrade -y
```
the output:
```sh
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Last metadata expiration check: 2 days, 18:50:25 ago on Mon 21 Oct 2024 03:19:32 PM WIB.
Dependencies resolved.
Nothing to do.
Complete!
Updating Subscription Management repositories.
Unable to read consumer identity

This system is not registered with an entitlement server. You can use subscription-manager to register.

Last metadata expiration check: 2 days, 18:50:31 ago on Mon 21 Oct 2024 03:19:32 PM WIB.
Dependencies resolved.
Nothing to do.
Complete!
```

After update the system, Then install basic standard packages:

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
```

### Step 2: Configure Hostname, Firewalld and SELinux

#### To verify if a hostname is a FQDN
Use the following sections to verify the hostnames that is used by the Chef Infra Server.

To verify if a hostname is resolvable and a FQDN (Fully Qualified Domain Name), run the following command:

```
hostname -f
```
the output:
```
[root@infraserver ~]# hostname -f
infraserver.chef.lab
```

#### Firewalld
To allow access to your Chef Infra Server on ports 80 and 443 via firewalld, issue the following command with root privileges:

```
firewall-cmd --permanent --zone public -add-service={http,https}
firewall-cmd --permanent --zone public --add-port=80/tcp --add-port=443/tcp 
firewall-cmd --reload
```

validate output from firewalld

```sh
[root@infraserver ~]# firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3
  sources:
  services: cockpit dhcpv6-client http https ssh
  ports: 80/tcp 443/tcp
  protocols:
  forward: no
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

#### SELinux 

On Red Hat Enterprise Linux systems, SELinux is enabled in enforcing mode by default. The Chef Infra Server does not have a profile available to run under SELinux. In order for the Chef Infra Server to run, SELinux must be disabled or set to ``Permissive`` mode.

To determine if SELinux is installed, run the following command:

```
getenforce
```

If a response other than ``"Disabled"`` or ``"Permissive"`` is returned, SELinux must be disabled.

To set SELinux to ``Permissive`` mode, run:

```
setenforce Permissive
```

and then check the status:

```
[root@infraserver ~]# getenforce
Permissive
```

### Step 3: Configure NTP 

The Chef Infra Server requires that the systems on which it is running be connected to Network Time Protocol (NTP), as the Chef Infra Server is particularly sensitive to clock drift.For Red Hat:

```
service chronyd start
```

The service status should show running
```sh
[root@infraserver ~]# service chronyd status
Redirecting to /bin/systemctl status chronyd.service
● chronyd.service - NTP client/server
   Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; vendor preset: e>
   Active: active (running) since Thu 2024-10-24 09:44:25 WIB; 1h 2min ago
     Docs: man:chronyd(8)
           man:chrony.conf(5)
  Process: 844 ExecStartPost=/usr/libexec/chrony-helper update-daemon (code=exited, s>
  Process: 828 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 840 (chronyd)
    Tasks: 1 (limit: 12373)
   Memory: 2.1M
   CGroup: /system.slice/chronyd.service
           └─840 /usr/sbin/chronyd

Oct 24 09:44:24 rhel.localdomain systemd[1]: Starting NTP client/server...
Oct 24 09:44:24 rhel.localdomain chronyd[840]: chronyd version 4.2 starting (+CMDMON >
Oct 24 09:44:24 rhel.localdomain chronyd[840]: Using right/UTC timezone to obtain lea>
Oct 24 09:44:25 rhel.localdomain systemd[1]: Started NTP client/server.
Oct 24 09:44:56 rhel.localdomain chronyd[840]: Selected source 202.162.32.12 (2.rhel.>
Oct 24 09:44:56 rhel.localdomain chronyd[840]: System clock wrong by 4.005564 seconds
Oct 24 09:45:00 rhel.localdomain chronyd[840]: System clock was stepped by 4.005564 s>
Oct 24 09:45:00 rhel.localdomain chronyd[840]: System clock TAI offset set to 37 seco>
```

That’s all. You now have NTP server working on RHEL 8 server. See how you can use the timedatectl command to synchronize the system clock with NTP server.

### Step 4: Download and Install Chef Infra Server

Visit the Chef Infra Server Downloads page choose the current or stable release version to Download.

```
wget https://packages.chef.io/files/stable/chef-server/13.2.0/el/8/chef-server-core-13.2.0-1.el7.x86_64.rpm
```

After downloading the package, install it with your distribution package manager.

```
dnf localinstall chef-server-core-13.2.0-1.el7.x86_64.rpm -y
```

Please be patient, as this installation may take some time to complete.

```sh
Dependencies resolved.
======================================================================================
 Package                 Architecture  Version              Repository           Size
======================================================================================
Installing:
 chef-server-core        x86_64        13.2.0-1.el7         @commandline        355 M

Transaction Summary
======================================================================================
Install  1 Package

Total size: 355 M
Installed size: 1.1 G
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                              1/1
  Installing       : chef-server-core-13.2.0-1.el7.x86_64                         1/1
  Running scriptlet: chef-server-core-13.2.0-1.el7.x86_64                         1/1
  Verifying        : chef-server-core-13.2.0-1.el7.x86_64                         1/1
Installed products updated.

Installed:
  chef-server-core-13.2.0-1.el7.x86_64

Complete!
```

### Step 5: Configure Chef Infra Server

Once the installation is complete, we need to reconfigure the chef server components for all Chef Server services to be configured properly and started.

```
chef-server-ctl reconfigure
```

Accept reconfigure by pressing the y key when asked.

```sh
+---------------------------------------------+
            Chef License Acceptance

Before you can continue, 3 product licenses
must be accepted. View the license at
https://www.chef.io/end-user-license-agreement/

Licenses that need accepting:
  * Chef Infra Server
  * Chef Infra Client
  * Chef InSpec

Do you accept the 3 product licenses (yes/no)?

> Prompt timed out. Use non-interactive flags or enter an answer within 60 seconds.

If you do not accept this license you will
not be able to use Chef products.

Do you accept the 3 product licenses (yes/no)?

> yes

Persisting 3 product licenses...
✔ 3 product licenses persisted.
```

Be patient as this may take some time to complete.

```sh
............................................................................
Recipe: private-chef::opscode-erchef
  * component_runit_service[opscode-erchef] action restart
  Recipe: <Dynamically Defined Resource>
    * service[opscode-erchef] action nothing (skipped due to action :nothing)
    * runit_service[opscode-erchef] action restart (up to date)
     (up to date)
Recipe: private-chef::rabbitmq
  * script[hard_kill_rabbitmq] action run
    - execute "bash"  "/tmp/chef-script20240910-21586-7kes6d"
Recipe: private-chef::partybus
  * execute[set initial migration level] action run
    - execute cd /opt/opscode/embedded/service/partybus && ./bin/partybus init
  * ruby_block[migration-level file sanity check] action run (skipped due to not_if)

Running handlers:
Running handlers complete
Chef Infra Client finished, 479/1031 resources updated in 05 minutes 17 seconds
Chef Server Reconfigured!
```

Chef Server components status can be checked by running the command:

```
chef-server-ctl status
```

the output:

```sh
run: bookshelf: (pid 39084) 77s; run: log: (pid 29407) 679s
run: nginx: (pid 39004) 80s; run: log: (pid 32907) 260s
run: oc_bifrost: (pid 38993) 81s; run: log: (pid 29103) 735s
run: oc_id: (pid 38996) 80s; run: log: (pid 29177) 713s
run: opscode-erchef: (pid 39108) 76s; run: log: (pid 29557) 674s
run: opscode-expander: (pid 39075) 77s; run: log: (pid 29268) 691s
run: opscode-solr4: (pid 39048) 78s; run: log: (pid 29245) 698s
run: postgresql: (pid 38991) 81s; run: log: (pid 28608) 777s
run: rabbitmq: (pid 32943) 257s; run: log: (pid 33098) 254s
run: redis_lb: (pid 38959) 86s; run: log: (pid 38957) 86s
```

All Chef Server services will run under the username/group ``opscode``. The username for PostgreSQL is ``opscode-pgsql``.

### Step 6: Create Admin user and Organization

Admin user account is not created automatically upon installation. We need to create one.

#### Create Chef Admin User

The syntax for creating user is:
``chef-server-ctl user create USERNAME FIRST_NAME [MIDDLE_NAME] LAST_NAME EMAIL PASSWORD``

```
chef-server-ctl user-create chefadmin Chef Admin chefadmin@chef.lab -f /root/chefadmin.pem --prompt-for-password
```

Used options:

```–prompt-for-password : Prompt for user password```

```-f: Write private key to file specified rather than STDOUT```

To view list of users, run:

```sh
[root@infraserver ~]# chef-server-ctl user-list
chefadmin
pivotal
```

#### Create Chef Organization

Next is to create an organization. An organization is the top-level entity for role-based access control in the Chef Infra Server. The Chef Infra Server supports multiple organizations.

The ```org-create``` subcommand is used to create an organization. Full command syntax is:

```chef-server-ctl org-create ORG_NAME "ORG_FULL_NAME" --association_user USERNAME --filename ORGANIZATION-validator.pem (options)```

Notes:

- The name must begin with a lower-case letter or digit,
- The full name must begin with a non-white space character
- The ``--association_user`` option will associate the user with the admins security group on the Chef server.
- An RSA private key is generated automatically. This is the chef-validator key and should be saved to a safe location.
- The ``--filename`` option will save the RSA private key to the specified absolute path.

```
chef-server-ctl org-create lab 'Chef Lab.' --association_user chefadmin --filename /root/lab-validator.pem
```

Verify organization creation:

```sh
[root@infraserver ~]# chef-server-ctl org-list
lab
```

You should have to RSA private keys under /root – For user and organization.

```sh
[root@infraserver ~]# find /root -name "*.pem"
/root/chefadmin.pem
/root/lab-validator.pem
```

### Step 7: Configure Data Collection 

Nodes must send their run data to Chef Automate through the Chef server. To enable this functionality, you must perform the following steps: 

All messages sent to Chef Automate are performed over HTTP and are authenticated with a pre-shared key called a token. Every Chef Automate installation configures a token by default, but we strongly recommend creating your own. 

Create a new token from Automate UI.  

``Go to Automate UI > settings > automate API > create and copy token.``

Run the following commands on Infra Server to set data collection settings. 

```chef-server-ctl set-secret data_collector token '<API_Token>'
```

Channel the token setting through the veil secrets library. 

```
chef-server-ctl restart nginx
chef-server-ctl restart opscode-erchef
```

Add the following setting by creating a new file ``chef-server.rb`` on Chef Server. ``vim chef-server.rb``

```sh
data_collector['root_url'] = 'https://<Automate_Server_IP_Or_Domain>/data-collector/v0/'

# Add for compliance scanning  
profiles['root_url'] = 'https://<Automate_Server_IP_Or_Domain>’
```

To apply the changes, run ``chef-server-ctl reconfigure``

## Additional Resources

- [Chef Infra Server Documentation](https://docs.chef.io/server/)
- [Chef Infra Server Prerequisites](https://docs.chef.io/server/install_server_pre/)
- [Chef Installation Guide](https://docs.chef.io/server/install_server/)
