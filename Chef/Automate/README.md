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

2. **Compliance Monitoring**

Chef Automate integrates with Chef InSpec to provide compliance and security monitoring. It allows users to write compliance profiles as code and automate checks against industry standards (such as PCI-DSS, HIPAA, and CIS benchmarks). This component ensures that infrastructure adheres to security and regulatory requirements.

3. **Application Monitoring**

Chef Automate supports Chef Habitat to automate and manage application lifecycles. With the Application Monitoring feature, you can monitor the performance and health of applications running in your infrastructure, tracking deployment pipelines and ensuring seamless operations from development to production.

4. **Infrastructure Monitoring**

Chef Automate works with Chef Infra to provide detailed insights into infrastructure health, configuration changes, and compliance enforcement. The system enables continuous deployment and management of infrastructure configurations, ensuring that all systems are compliant and up-to-date with desired policies.

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

### Step 2: Create Default Configuration (Optionals)

Create a ``config.toml`` file with default values for your Chef Automate installation:
```
chef-automate init-config
```

You can customize your FQDN, login name, and other values, by changing the values in the ``config.toml`` in your editor.

### Step 3: Deploy Chef Automate

```
chef-automate deploy --product automate --product infra-server --product builder (Optional if you want to install Chef Infra Server and Chef Habitat Builder on the same server)
```

The deployment process takes a few minutes. The first step is to accept the terms of service via the command line, after which the installer will perform a series of pre-flight checks to ensure everything is ready for installation.

Once the installation is complete, you can access the Chef Automate dashboard. For example, the dashboard might be available at ``https://automate.chef.lab``. The login credentials for Chef Automate are stored in a file that is generated automatically in the home directory on your Automate host during installation.

To view the credentials, run:
```
cat ~/automate-credentials.toml
```

If this file is not created automatically, you can manually generate an admin access password using the following command:
```
chef-automate iam admin-access restore ``"your_password"``
```

### Step 4: Verify the status of the Chef Automate service

```
chef-automate status
```

Please open the browser to ensure the dashboard is available. 

## Additional Resources

- [Chef Automate Documentation](https://docs.chef.io/automate/)
- [Chef Infra Documentation](https://docs.chef.io/server/)
- [Chef Habitat Documentation](https://docs.chef.io/habitat/)
- [Chef InSpec Documentation](https://docs.chef.io/inspec/)