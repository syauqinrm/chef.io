# Chef Infra Server

In this documentation will explain ... 

## Table of Contents

1. [Chef Infra Server Overview](#overview)

2. [Chef Infra Server Prerequisites](#chef-infra-server-prerequisites)

3. [Install](#install-and-configure)

4. []

## Overview

Chef Infra is a powerful configuration management tool that automates the process of provisioning, configuring, and managing infrastructure. It transforms infrastructure into code, allowing system administrators and developers to define the desired state of their systems and automate the process of ensuring consistency across environments. Whether your infrastructure is on-premises, in the cloud, or in a hybrid environment, Chef Infra helps maintain consistency and reliability by enforcing infrastructure policies through continuous automation.

Chef Infra works by applying a set of configuration instructions, known as cookbooks and recipes, to each managed node in your infrastructure. These cookbooks define how a system should be configured, from software installations to service management and system settings. The Chef Infra Client, installed on every managed node, regularly checks in with the Chef Infra Server to retrieve the latest configuration changes and applies them if necessary, ensuring the nodes converge to the desired state.

Chef Infra provides scalability and flexibility, allowing organizations to manage thousands of servers effortlessly. It ensures that infrastructure remains compliant with business policies and security standards by continuously monitoring and enforcing the defined configurations. By integrating Chef Infra into your infrastructure management workflow, you can reduce human error, speed up deployments, and ensure a high level of operational efficiency.

### Infra Server Components

The Chef Infra Server consists of several core components that work together to store, manage, and distribute configuration data across your infrastructure. Each component has a specific role, ensuring that configuration changes are applied consistently and securely to all nodes under management. Below is a b  reakdown of the key components within the Chef Infra Server architecture:

| Component         | Description                                                                                                                                                                                                 |
|-------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Clients**       | The Chef Infra Server is accessed by nodes managed by Chef Infra Client during client runs. It is also accessed by users maintaining cookbooks and policies, typically from workstations, and by authenticated users. |
| **Load Balancer** | Nginx is used as the front-end load balancer for the Chef Infra Server. It routes all requests to the Chef Infra Server API through Nginx, providing HTTP and reverse proxy services.                         |
| **Chef Manage**   | The web interface for Chef Infra Server, Chef Manage, communicates with the Chef Infra Server using the Chef Infra Server API.                                                                                |
| **Chef Infra Server** | Erchef is the core API for the Chef Infra Server, written in Erlang for improved scalability and performance. It is compatible with the original Ruby-based server, so existing cookbooks and recipes remain functional.|
| **Bookshelf**     | Bookshelf stores cookbook content—files, templates, and more—uploaded to Chef Infra Server as part of a cookbook version. It uses checksums to store files only once, even across different versions or cookbooks.|
| **Messages**      | chef-elasticsearch wraps Elasticsearch, exposing its REST API for indexing and search, storing messages in a dedicated search index repository.                                                               |
| **PostgreSQL**    | PostgreSQL serves as the primary data storage repository for the Chef Infra Server.                                                                                                                           |

### How Infra Server Works

## Chef Infra Server Prerequisites

### Supported Platforms for Chef Infra Server

The following table lists the commercially supported platforms for Chef Infra Server:

| Platform                         | Architecture | Version            |
|----------------------------------|--------------|--------------------|
| Amazon Linux                     | x86_64       | 2, 2023            |
| Red Hat Enterprise Linux         | x86_64       | 8.x, 9.x           |
| Rocky Linux                      | x86_64       | 9.x                |
| SUSE Linux Enterprise Server     | x86_64       | 12.x, 15.x         |
| Ubuntu                           | x86_64       | 20.04, 22.04       |

### Hardware Requirements

All machines in a Chef Infra Server deployment have the following hardware requirements. Disk space for standalone and backend servers should scale up with the number of nodes that the servers are managing. A good rule to follow is to allocate 2 MB for each node. The disk values listed below should be a good default value that you will want to modify later if/when your node count grows. Fast, redundant storage (SSD/RAID-based solution either on-prem or in a cloud environment) is preferred.

**All Deployments**

- 64-bit CPU architecture
- CPU support for SSE4.2 extensions (Xeons starting in 2007 and Opterons in 2012)

**Standalone Deployments**

- 4 total cores (physical or virtual)
- 8 GB of RAM or more
- 5 GB of free disk space in /opt
- 10 GB of free disk space in /var
- For a high availability deployment:

**General Requirements**

- Three backend servers; as many frontend servers as required
- 1 x GigE NIC interface (if on premises)

**Frontend Requirements**

- 4 cores (physical or virtual)
- 4GB RAM
- 20 GB of free disk space (SSD if on premises, Premium Storage in Microsoft Azure, EBS-Optimized GP2 in AWS)

**Backend Requirements**

- 2 cores (physical or virtual)
- 8GB RAM
- 50 GB/backend server (SSD if on premises, Premium Storage in Microsoft Azure, EBS-Optimized GP2 in AWS)

### Software Requirements

Before installing the Chef Infra Server, ensure that each machine has the following installed and configured properly:

- **Hostnames** — Ensure that all systems have properly configured hostnames. The hostname for the Chef Infra Server must be a FQDN, have fewer than 64 characters including the domain suffix, be lowercase, and resolvable. See Hostnames, FQDNs for more information
- **FQDNs** — Ensure that all systems have a resolvable FQDN
- **NTP** — Ensure that every server is connected to NTP; the Chef Infra Server is sensitive to clock drift
- **Mail Relay** — The Chef Infra Server uses email to send notifications for various events; a local mail transfer agent should be installed and available to the Chef server
- **cron** — Periodic maintenance tasks are performed using cron
- **git** — git must be installed so that various internal services can confirm revisions
- **Apache Qpid** — This daemon must be disabled on CentOS and Red Hat systems
- **Required users** — If the environment in which the Chef Infra Server will run has restrictions on the creation of local user and group accounts, ensure that the correct users and groups exist before reconfiguring
- **Firewalls and ports** — If host-based firewalls (iptables, ufw, etc.) are being used, ensure that ports 80 and 443 are open.

In addition:

- **Browser** — Firefox, Google Chrome, Safari, or Internet Explorer (versions 9 or better)
Chef Infra Client communication with the Chef Infra Server The Chef Infra Server must be able to communicate with every node that will be configured by Chef Infra Client and every workstation that will upload data to the Chef Infra.

## Install and Configure

In this section, we will demonstrate how to install and configure Chef Infra Server on RHEL 8.7 (Red Hat Enterprise Linux). The steps will guide you through setup, downloading and installing the necessary packages, configuring the system, and ensuring that the Chef Infra Server is up and running.

### Step 1: Update The System

### Step 2: Configure NTP 
### Step 3: 
