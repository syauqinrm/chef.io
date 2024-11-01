# Chef Automate

This documentation provides a comprehensive guide on setting up, configuring, and using Chef Automate. It covers the system requirements, core components, and installation steps.

## Table of Contents

1. [Chef Automate Overview](#overview)
2. [Chef Automate: System Requirements](#system-requirements)
3. [Setup](#setup)
4. [Install](#download-and-install)
5. [Additional Resources](#additional-resources)

## Overview

Chef Automate is an enterprise platform that provides visibility, compliance monitoring, and application lifecycle management for infrastructures managed with Chef Infra and Chef Habitat. It integrates seamlessly with Chef’s ecosystem, offering a unified interface for continuous automation, compliance, and monitoring across your infrastructure.

Chef Automate delivers real-time data on your infrastructure, providing insights into configuration management, application monitoring, and security compliance. With Chef Automate, teams can automate workflows, enforce compliance policies, and monitor infrastructure performance, all from a single dashboard.

### Chef Automate Components

Chef Automate consists of several core components that provide a wide range of functionality, from compliance monitoring to application management:

1. **Web UI**

The Chef Automate Web UI is a user-friendly interface that allows users to manage their infrastructure, view compliance reports, and monitor system health in real-time. The UI provides dashboards for tracking configuration changes, compliance status, and detailed application performance metrics.

![](/src/img/automate-web-ui.png)

2. **Compliance Monitoring**

Chef Automate integrates with Chef InSpec to provide compliance and security monitoring. It allows users to write compliance profiles as code and automate checks against industry standards (such as PCI-DSS, HIPAA, and CIS benchmarks). This component ensures that infrastructure adheres to security and regulatory requirements.

3. **Application Monitoring**

Chef Automate supports Chef Habitat to automate and manage application lifecycles. With the Application Monitoring feature, you can monitor the performance and health of applications running in your infrastructure, tracking deployment pipelines and ensuring seamless operations from development to production.

4. **Infrastructure Monitoring**

Chef Automate works with Chef Infra to provide detailed insights into infrastructure health, configuration changes, and compliance enforcement. The system enables continuous deployment and management of infrastructure configurations, ensuring that all systems are compliant and up-to-date with desired policies.

![](/src/img/automate-infra-ui.jpg)

5. **Workflow Automation**

Chef Automate allows you to define and automate workflows, ensuring smooth and automated processes across development, testing, and production environments. It supports version control integration (like Git), allowing infrastructure and application changes to pass through continuous integration (CI) and continuous delivery (CD) pipelines before being applied.

## System Requirements

### Hardware
Chef Automate requires a minimum of:

- 4 GB of RAM
- 35 GB of disk space
- 2 vCPUs

### Operating system
Chef Automate requires:

- a Linux kernel of version 3.2 or greater
- systemd as the init system
- useradd
- ``curl`` or ``wget``
- The shell that starts Chef Automate should have a max open files setting of at least 65535

Commercial support for Chef Automate is available for platforms that satisfy these criteria.

### Supported Browsers
Chef Automate supports the current browser versions for Chrome, Edge, and Firefox. Chef Automate does not support other browsers and may not be compatible with older browser versions.

## Setup 

### Step 1: Update The System

```
dnf update -y && dnf upgrade -y
```
### Step 2: Verify Hostname is a FQDN

Set the fully qualified domain name with ``hostnamectl set-hostname hostname``. It’s critical that the ``fqdn`` value in the file matches the ``hostname –f`` value of the system.

```
hostname -f
```

### Step 3: Set The Mandatory Environment Variables  

```
sysctl -w vm.max_map_count=262144
sysctl -w vm.dirty_expire_centisecs=20000
```

Ensure these are written to /etc/sysctl.conf  so, it persists across reboots. 

### Step 4: Configure SELinux

On Red Hat Enterprise Linux systems, SELinux is enabled in enforcing mode by default. The Chef Automate does not have a profile available to run under SELinux. In order for the Chef Automate to run, SELinux must be disabled or set to ``Permissive`` mode.

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
[root@automate ~]# getenforce
Permissive
```

### Step 5: Configure Firewalld

To allow access to your Chef Automate on ports 80 and 443 via firewalld, issue the following command with root privileges:

```
firewall-cmd --permanent --zone public --add-service={http,https}
firewall-cmd --permanent --zone public --add-port=80/tcp --add-port=443/tcp 
firewall-cmd --reload
```

validate output from firewalld

```sh
[root@automate ~]# firewall-cmd --list-all
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

## Download and Install

### Step 1: Download Chef Automate

Download and unzip the Chef Automate command-line tool:
```
curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
```

the output:
```
[root@automate ~]# curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 13.4M  100 13.4M    0     0  1796k      0  0:00:07  0:00:07 --:--:-- 2759k
```

### Step 2: Create Default Configuration (Optionals)

Create a ``config.toml`` file with default values for your Chef Automate installation:
```
./chef-automate init-config
```

You can customize your FQDN, login name, and other values, by changing the values in the ``config.toml`` in your editor.

### Step 3: Deploy Chef Automate

```
./chef-automate deploy --product automate --product infra-server --product builder (Optional if you want to install Chef Infra Server and Chef Habitat Builder on the same server)
```

the output:
```
Automate deployment non HA mode proceeding...
To continue, you'll need to accept our terms of service:

Terms of Service
https://www.chef.io/terms-of-service

Master License and Services Agreement
https://www.chef.io/online-master-agreement

I agree to the Terms of Service and the Master License and Services Agreement
 (y/n)
y

Beginning pre-flight checks

 OK | running as root
 OK | volume: has 29.4GB avail (need 5.0GB for installation)
 OK | SELinux is not enabled
 OK | chef-automate CLI is not in /bin
 OK | automate not already deployed
 OK | initial required ports are available
 OK | init system is systemd
 OK | found required command "useradd"
 OK | user "nobody" exists
 OK | MemTotal 3568140 kB (3.6GB) is at least 2000000 kB (2.0GB)
 OK | fs.file-max=351438 is at least 64000
 OK | vm.max_map_count=262144 is at least 262144
 OK | vm.dirty_ratio=30 is between 5 and 30
 OK | vm.dirty_background_ratio=10 is between 10 and 60
 OK | vm.dirty_expire_centisecs=20000 is between 10000 and 30000
 OK | kernel version "4.18" is at least "3.2"
 OK | https://licensing.chef.io/status is reachable
 OK | https://bldr.habitat.sh is reachable
 OK | https://raw.githubusercontent.com is reachable
 OK | https://packages.chef.io is reachable
 OK | https://github.com is reachable
 OK | https://downloads.chef.io is reachable


Bootstrapping Chef Automate
  Fetching Release Manifest
  Installing Habitat
  Installing Habitat 1.6.521/20220603154827
  Installing the Chef Automate deployment-service
  Installing supplementary Habitat packages
  Installing Habitat package automate-cli
  Installing Habitat package rsync
  Installing Habitat package hab-sup
  Installing Habitat package hab-launcher
  Installing Habitat systemd unit
  Creating Habitat user and group
  Starting Habitat with systemd

Bootstrapping deployment-service on localhost
  Configuring deployment-service
  Starting deployment-service
  Waiting for deployment-service to be ready
  Initializing connection to deployment-service

Applying Deployment Configuration

Starting deploy
  Installing deployment-service
  Installing automate-cli
  Installing backup-gateway
  Installing automate-postgresql
  Installing automate-pg-gateway
  Installing automate-opensearch
  Installing automate-es-gateway
  Installing automate-ui
  Installing pg-sidecar-service
  Installing cereal-service
  Installing event-service
  Installing authz-service
  Installing es-sidecar-service
  Installing event-feed-service
  Installing automate-dex
  Installing teams-service
  Installing session-service
  Installing authn-service
  Installing secrets-service
  Installing applications-service
  Installing notifications-service
  Installing nodemanager-service
  Installing compliance-service
  Installing license-control-service
  Installing local-user-service
  Installing config-mgmt-service
  Installing ingest-service
  Installing infra-proxy-service
  Installing data-feed-service
  Installing event-gateway
  Installing report-manager-service
  Installing user-settings-service
  Installing automate-gateway
  Installing automate-cs-bookshelf
  Installing automate-cs-oc-bifrost
  Installing automate-cs-oc-erchef
  Installing automate-cs-ocid
  Installing automate-cs-nginx
  Installing automate-load-balancer
  Configuring deployment-service
  Starting backup-gateway
  Starting automate-postgresql
  Starting automate-pg-gateway
  Starting automate-opensearch
  Starting automate-es-gateway
  Starting automate-ui
  Starting pg-sidecar-service
  Starting cereal-service
  Starting event-service
  Starting authz-service
  Starting es-sidecar-service
  Starting event-feed-service
  Starting automate-dex
  Starting teams-service
  Starting session-service
  Starting authn-service
  Starting secrets-service
  Starting applications-service
  Starting notifications-service
  Starting nodemanager-service
  Starting compliance-service
  Starting license-control-service
  Starting local-user-service
  Starting config-mgmt-service
  Starting ingest-service
  Starting infra-proxy-service
  Starting data-feed-service
  Starting event-gateway
  Starting report-manager-service
  Starting user-settings-service
  Starting automate-gateway
  Starting automate-cs-bookshelf
  Starting automate-cs-oc-bifrost
  Starting automate-cs-oc-erchef
  Starting automate-cs-ocid
  Starting automate-cs-nginx
  Starting automate-load-balancer

Checking service health
  ┴
```

The deployment process takes a few minutes. The first step is to accept the terms of service via the command line, after which the installer will perform a series of pre-flight checks to ensure everything is ready for installation.

Once the installation is complete, you can access the Chef Automate dashboard. For example, the dashboard might be available at ``https://automate.chef.lab``. The login credentials for Chef Automate are stored in a file that is generated automatically in the home directory on your Automate host during installation.

To view the credentials, run:
```
cat ~/automate-credentials.toml
```

If this file is not created automatically, you can manually generate an admin access password using the following command:
```
chef-automate iam admin-access restore "your_password"
```

### Step 4: Verify the status of the Chef Automate service

```
chef-automate status
```

the output:
```
[root@automate ~]# chef-automate status

Status from deployment with channel [current] and type [local]

Service Name            Process State  Health Check  Uptime (s) PID
deployment-service      running        ok            2588       11592
backup-gateway          running        ok            3062       14512
automate-postgresql     running        ok            3059       17137
automate-pg-gateway     running        ok            3058       17201
automate-opensearch     running        ok            3062       14828
automate-es-gateway     running        ok            3060       11366
automate-ui             running        ok            3061       15031
pg-sidecar-service      running        ok            3063       14930
cereal-service          running        ok            3062       15526
event-service           running        ok            3063       14654
authz-service           running        ok            3056       17377
es-sidecar-service      running        ok            2891       23095
event-feed-service      running        ok            2887       23233
automate-dex            running        ok            3060       15231
teams-service           running        ok            3063       15185
session-service         running        ok            3061       14863
authn-service           running        ok            3063       15441
secrets-service         running        ok            3062       15509
applications-service    running        ok            3061       15157
notifications-service   running        ok            3057       17305
nodemanager-service     running        ok            3017       18487
compliance-service      running        ok            2894       22971
license-control-service running        ok            3058       17216
local-user-service      running        ok            3060       14810
config-mgmt-service     running        ok            2887       23203
ingest-service          running        ok            2885       23296
infra-proxy-service     running        ok            3062       15135
data-feed-service       running        ok            3064       15736
event-gateway           running        ok            3064       14615
report-manager-service  running        ok            3058       17238
user-settings-service   running        ok            3051       17569
automate-gateway        running        ok            3061       11462
automate-cs-bookshelf   running        ok            3057       17253
automate-cs-oc-bifrost  running        ok            3051       17581
automate-cs-oc-erchef   running        ok            2882       23364
automate-cs-ocid        running        ok            2826       24721
automate-cs-nginx       running        ok            3063       14696
automate-load-balancer  running        ok            3061       14894

```

Please open the browser to ensure the dashboard is available. 

## Additional Resources

- [Chef Automate Documentation](https://docs.chef.io/automate/)
- [Chef Infra Documentation](https://docs.chef.io/server/)
- [Chef Habitat Documentation](https://docs.chef.io/habitat/)
- [Chef InSpec Documentation](https://docs.chef.io/inspec/)
