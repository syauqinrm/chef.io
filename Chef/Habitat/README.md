# Chef Habitat

This documentation provides a comprehensive guide on setting up, using, and understanding Chef Habitat, an application automation tool that simplifies how applications are built, deployed, and managed.

## Table of Contents

1. [Overview](#overview)
2. [Chef Habitat Components](#chef-habitat-components)
3. [When Should I Use Chef Habitat?](#when-should-i-use-chef-habitat)
4. [System Requirements](#system-requirements)
5. [Download and Install Chef Habitat](#download-and-install-chef-habitat)
6. [Getting Started with Chef Habitat](#getting-started-with-chef-habitat)
7. [Additional Resources](#additional-resources)

## Overview

Chef Habitat is an open-source automation tool that focuses on defining, packaging, and delivering applications consistently across any environment. By using Habitat, you can manage your applications as self-contained, deployable artifacts with their dependencies and configurations defined in code. This allows teams to build, deploy, and run applications in cloud, on-premise, or hybrid environments without worrying about differences in system configurations.

Chef Habitat provides a lightweight, flexible framework for building, managing, and monitoring your applications, allowing you to automate the entire lifecycle—from development to production.

![](src\img\chef-habitat.png)

### Chef Habitat Components

1. Habitat Builder

Habitat Builder is a core part of Chef Habitat’s ecosystem. It’s a cloud or on-premises service that allows users to build, store, and manage Habitat packages. Habitat Builder automates the process of building applications and their dependencies, and provides a repository where packages can be stored and accessed. With Habitat Builder, teams can easily manage package lifecycles and ensure consistent builds across multiple environments.

Key features include:
- Automated build and release pipelines
- Storing public or private packages
- API for managing package distribution
- Search and access to community and enterprise Habitat packages

2. Origin

An **Origin** in Chef Habitat is a namespace that acts as the unique identifier for packages you build. It's where Habitat packages are signed and stored. Each origin has its own signing key that is used to sign all packages produced under that origin. This ensures that packages can be verified as coming from a trusted source.

- Origin Keys: These are the cryptographic keys associated with your origin. They sign packages so you can verify their integrity.
- Origin Sharing: Origins can be public or private, depending on whether the packages are shared with the community or kept secure in an on-premise environment.
Example:
```
hab origin key generate <your_origin>
```

3. Habitat Package

A **Habitat Package** is the core artifact in Chef Habitat, representing an application and all of its dependencies. These packages are built from plans and include everything needed to run the application in any environment. The resulting package is immutable, ensuring consistency across deployments.

Habitat packages:

- Are stored as ``.hart`` files (Habitat Artifacts).
- Contain the application, configuration, and lifecycle management scripts.
- Can be exported to different environments like containers or virtual machines.

4. Plan

A Plan is a collection of scripts and configuration files that defines how Chef Habitat should download, build, configure, and deploy an application. It contains the instructions necessary to package an application and ensure that all dependencies are accounted for.

Key components of a plan:

- plan.sh or plan.ps1: Defines how the application is built.
- default.toml: Holds the configuration values.
- hooks: Custom lifecycle hooks that can be triggered at different stages (e.g., starting or stopping a service).
The plan resides in the ``habitat/`` directory at the root of the project.

Example:
```
hab plan init
```

5. Services

A Service in Habitat is an instance of a running Habitat package that is managed by the Habitat Supervisor. Services can be run in various topologies and environments. They can be connected in a Service Group, which enables multiple services of the same package to communicate with each other across different systems.

- Topology: Services can be configured as standalone, leader-follower, or other more complex arrangements.
- Service Groups: These are collections of services running the same Habitat package, coordinated by Supervisors to ensure proper interaction between them.


6. Habitat Studio

**Habitat Studio** is an isolated, self-contained environment used for building and testing Habitat packages. It ensures that no external dependencies from the underlying OS affect the build process, thereby providing a consistent and clean environment for developing applications.

Features of Habitat Studio:

- **Build Environment**: All dependencies are managed within Habitat Studio, ensuring consistency.
- **Testing**: You can test packages before they are deployed to production.
Start a Habitat Studio:
```
hab studio enter
```

7. Habitat Supervisors 

The **Habitat Supervisor** is responsible for running and managing services that are packaged with Habitat. It handles the lifecycle of services, including starting, stopping, updating, and monitoring them. The Supervisor can also communicate with other Supervisors in the network, allowing distributed services to work together.

Key responsibilities:

- **Service Management**: Start, stop, update, and monitor the health of services.
- **Topology Management**: Define the application’s structure (leader-follower, standalone, etc.).
- **Networked Supervisors**: Supervisors can share data and coordinate actions across nodes, enabling more complex architectures like clustered databases or microservices.
Start a Supervisor:
```
hab svc load <origin>/<package>
```

### When Should I Use Chef Habitat?

- **Application Lifecycle Management**:
Use Habitat when you need a flexible, automated way to manage the lifecycle of your applications, including building, testing, deploying, and updating across different environments.

- **Multi-Environment Consistency**:
Habitat is ideal for maintaining consistency in application deployment across various environments—on-premise, cloud, or hybrid—by packaging applications with all their dependencies.

- **Microservices and Cloud-Native Apps**:
If your organization is moving towards microservices, containers, or cloud-native applications, Habitat simplifies the packaging and orchestration of these services.

- **Improved Deployment Pipelines**:
Integrate Habitat with your CI/CD pipelines to ensure that applications are built once and deployed consistently in any environment, from development to production.

## System Requirements

Before installing Chef Habitat, ensure that your system meets the following requirements:

### Operating System:
- Linux (most distributions are supported)
- macOS (for development purposes)
- Windows (limited support for packaging and running applications)

### Hardware Requirements:
- Minimum 2 GB of RAM
- 10 GB of free disk space
- 2 CPU cores

### Additional Tools:
- Docker (optional for containerized builds)
- Git

## Download and Install Chef Habitat

you can go to chef official download package 

Alternatively, you can install Chef Habitat via the command line by downloading and running the installation script:
```
curl https://raw.githubusercontent.com/habitat-sh/habitat/main/components/hab/install.sh | sudo bash
```

the output:
```sh
% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9420  100  9420    0     0  23550      0 --:--:-- --:--:-- --:--:-- 23550

--> hab-install: Installing Habitat 'hab' program
--> hab-install: Downloading via wget: https://packages.chef.io/files/stable/habitat/latest/hab-x86_64-linux.tar.gz
--> hab-install: Downloading via wget: https://packages.chef.io/files/stable/habitat/latest/hab-x86_64-linux.tar.gz.sha256sum
renamed '/var/tmp/tmp.bYaS3wusHD/hab-latest.tar.gz' -> 'hab-x86_64-linux.tar.gz'
renamed '/var/tmp/tmp.bYaS3wusHD/hab-latest.tar.gz.sha256sum' -> 'hab-x86_64-linux.tar.gz.sha256sum'
--> hab-install: GnuPG tooling found, downloading signatures
--> hab-install: Downloading via wget: https://packages.chef.io/files/stable/habitat/latest/hab-x86_64-linux.tar.gz.sha256sum.asc
--> hab-install: Downloading via wget: https://packages.chef.io/chef.asc
--> hab-install: GnuPG tooling found, verifying the shasum digest is properly signed
gpg: directory '/home/builder/.gnupg' created
gpg: keybox '/home/builder/.gnupg/pubring.kbx' created
gpg: assuming signed data in 'hab-x86_64-linux.tar.gz.sha256sum'
gpg: Signature made Mon Oct 26 12:15:52 2020 CDT
gpg:                using DSA key 11685DB92F03640A2FFE7CA82940ABA983EF826A
gpg: /home/builder/.gnupg/trustdb.gpg: trustdb created
gpg: Good signature from "CHEF Packages <packages@chef.io>" [unknown]
gpg:                 aka "Opscode Packages <packages@opscode.com>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 1168 5DB9 2F03 640A 2FFE  7CA8 2940 ABA9 83EF 826A
--> hab-install: Verifying the shasum digest matches the downloaded archive
hab-x86_64-linux.tar.gz: OK
--> hab-install: Extracting hab-x86_64-linux.tar.gz
--> hab-install: Installing Habitat package using temporarily downloaded hab
» Installing core/hab
☁ Determining latest version of core/hab in the 'stable' channel
↓ Downloading core/hab/1.6.175/20201026161911 for x86_64-linux
    5.26 MB / 5.26 MB / [============================================================] 100.00 % 184.23 MB/s
☛ Verifying core/hab/1.6.175/20201026161911
↓ Downloading core-20180119235000 public origin key
    75 B / 75 B | [====================================================================] 100.00 % 3.03 MB/s
☑ Cached core-20180119235000 public origin key
✓ Installed core/hab/1.6.175/20201026161911
★ Install of core/hab/1.6.175/20201026161911 complete with 1 new packages installed.
» Binlinking hab from core/hab/1.6.175/20201026161911 into /bin
★ Binlinked hab from core/hab/1.6.175/20201026161911 to /bin/hab
--> hab-install: Checking installed hab version
hab 1.6.175/20201026161911
--> hab-install: Installation of Habitat 'hab' program complete.
```

## Getting Started With Chef Habitat 

This getting started guide will show you how to use Chef Habitat to build and deploy a Node.js application.

### Step 1: Prerequisites

Before getting started with this tutorial, you will need:

- a workstation running Linux or macOS
- a [GitHub](https://github.com/join) account
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed locally (optional)
- the [Chef Habitat CLI](https://docs.chef.io/habitat/install_habitat/) installed locally
- an account on [Chef Habitat Builder](https://docs.chef.io/habitat/builder_account/)
- a [profile on your Builder account](https://docs.chef.io/habitat/builder_profile/)

### Step 2: Setup the Habitat CLI

Before you can build the app, you'll need to create an origin and accompanying keys. The quickest way to do this is by running ``hab setup`` as described in the Habitat docs and following the prompts:

```
hab setup
```

Note: The origin name you use during setup will need to be specified in the ``plan.sh`` file mentioned in the next section.

### Step 3: Clone the Habitat sample-node-app repository

Clone this repository:
```
$ git clone https://github.com/habitat-sh/sample-node-app.git
$ cd sample-node-app
```

### Step 4: Edit the Plan File

From the habitat directory in this repository, open the ``plan.sh file``. It should look like this:

```
pkg_origin=your_origin
pkg_name=sample-node-app
pkg_version="1.1.0"
pkg_deps=(core/node)
...
```

Next, let's change the version number:
```
pkg_version="1.1.1"
```

Save and close the file

### Step 5: Building the Package

Then enter the Habitat Studio:

```
hab studio enter
```

And run a build:

```
[1][default:/src:0]# build
```

Habitat will produce a package (a ``.hart`` file) and place it in the ``results`` directory.

Then check the package
```
[2][default:/src:0]# source results/last_build.env
```

### Step 6: Install the Package

Next install the package
```
[3][default:/src:0]# hab pkg install results/$pkg_artifact (or name the package.hart)
```

### Step 5: Run the Service in the Habitat Studio

start the package on habitat studio
```
[3][default:/src:0]#hab svc load <YOUR_ORIGIN>/sample-node-app
```

Now head to http://localhost:8000 and see your running app!

![](src\img\sample-node-js.png)

## Additional Resources

- [Habitat Doc](https://docs.chef.io/habitat/) 
- [Habitat Builder](https://bldr.habitat.sh/)
- [Sample Node App](https://docs.chef.io/habitat/get_started/)

