# Chef Workstation

This documentation provides a comprehensive guide on setting up and using Chef Workstation. It explains how Chef Workstation serves as the central tool for infrastructure automation by providing all the necessary resources for creating, testing, and deploying infrastructure as code (IaC). The document also covers the workflow for developing cookbooks, configuring the Chef environment, and deploying configurations to nodes.

## Table of Contents

1. [Chef Workstation Overview](#overview)

2. [Chef Workstation Requirements](#chef-workstation-requirements)

3. [Install Chef Workstation](#install)

4. [Configure Knife Environment](#configure-knife-environment)

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

### Step 1: Update The System

Ensure that your system is up to date by running the necessary update commands.


### Step 2: Configure NTP

Ensure that Network Time Protocol (NTP) is properly configured to synchronize time across systems.



### Step 4: Download and Install Chef Workstation

Install Chef Workstation on RHEL 8 by downloading the latest release on Chef Workstation releases page.

```
wget https://packages.chef.io/files/stable/chef-workstation/20.7.96/el/8/chef-workstation-20.7.96-1.el7.x86_64.rpm
```

## Configure Knife Environment

### Step 1: Generate Chef repositories 

### Step 2: Configure Knife 

## Write a test Cookbooks

### Step 1: Generate cookbook

### Step 2: Create Recipes

### Step 3: Upload Cookbook to Chef Infra Server

## Bootstrapping to Nodes

### Step 1: Create a SSH keygen 

### Step 2: Copy SSH id_rsa.pub to Client/Node

### Step 3: Bootstrapping to Node

## Additional Resources

- []()
- []()
- []()