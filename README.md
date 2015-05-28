# proxmox

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with proxmox](#setup)
    * [What proxmox affects](#what-proxmox-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with proxmox](#beginning-with-proxmox)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Author & Copryright - Copyright notice](#author-copyright)

## Overview

This module can install and configure Proxmox Virtual Environment.
It automatically sets up recommended configuration and allows source based routing
for OpenVZ containers. NAT cannot be managed through this module.

## Module Description

You can specify the kernel to boot for both OpenVZ and KVM. Further it can install
custom SSL certificates, install custom grub version and automatically fixes /etc/hosts.
If wanted, it installs an customised bashrc for better SSH style and manages complete networking.
All Proxmox services are monitored and automatically started. Detects when in a cluster and ensures,
that cman is running.

Repository can be manually changed if you run an intranet or similar and package versions can be changed easily.

Works with Foreman (theforeman.org)

## Setup

### What proxmox affects

* Installs all Proxmox VE packages and monitors them
* Automatically sets up repository in /etc/apt/sources.list.d/
* Bootloader will be updated to Grub2 when specified

### Setup Requirements

Networking must be configured via params.pp. Can be automatically managed by Foreman.
puppetlabs-apt, puppetlabs-stdlib, puppet-sysctl, example42-network and puppetlabs-ntp modules are required

### Beginning with proxmox

Just install the module and get started.
Basic Proxmox class must be included and then one role
e.g. proxmox::role::openvz_node or proxmox::role::kvm_node

## Usage

Configuration is managed by the class proxmox::params

## Limitations

Only distribution supported is Debian as Proxmox VE is Debian based. Tested version is
7 (wheezy) with Promox VE 3.3 and 3.4.

## Author & Copyright

Authored by Henry Spanka <henry@myvirtualserver.de>
Usage or distribution prohibited without permission by the author.
