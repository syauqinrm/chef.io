# Chef Infra Server

## Getting Started

## Chef Infra Server Prerequisites

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

##