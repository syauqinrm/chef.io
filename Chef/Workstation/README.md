# Chef Workstation

This documentation (berisikan apa dokumen ini(rangkuman singkat/tolong buatkan ya chatgpt))

## Table of Contents

1. [Chef Workstation Overview](#overview)

2. [Chef Workstation Requirements](#chef-workstation-requirements)

3. [Install Chef Workstation](#install)

4. [Configure Knife Environment](#configure-knife-environment)

5. [Write Test Cookbooks](#write-a-test-cookbooks)

6. [Bootstrapping to Nodes](#bootstrapping-to-nodes)

7. [Additional Resources](#additional-resources)

## Overview

(tolong buatkan overview terkait chef workstation ya chatgpt)

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



### System Requirements

## Install 

### Step 1: Update The System

### Step 2: Configure NTP

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


If a hostname is not resolvable, refer to a local systems administrator for specific guidance on how to add the hostname to the DNS system. If the Chef Infra Server is being into a testing environment, just add the hostname to ``/etc/hosts``. The following example shows how a hostname can be added to ``/etc/hosts`` when running Red Hat or CentOS:

```

```