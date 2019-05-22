
# puppet-sal

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with sal](#setup)
    * [What sal affects](#what-sal-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sal](#beginning-with-sal)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)

## Description

Puppet module for installing and configuring the LSST Service Abstraction Layer (SAL).

For more information about the LSST SAL software, see the following:

  * https://github.com/lsst-ts/ts_sal/
  * https://github.com/lsst-ts/ts_sal/blob/develop/lsstsal/doc/SAL_User_Guide.pdf

## Setup

### What sal affects

The module installs prerequisites, installs the SAL software (OpenSplice & CSC libraries), and configures firewall settings.

### Setup Requirements

The following parameters must be defined:

  * `sal::install::yumrepo_baseurl` - String of yum repository baseurl containing OpenSpliceDDS package

This module requires the following puppet modules to be installed:

  * https://github.com/LSST-IT/puppet-python3
  * https://forge.puppet.com/puppetlabs/firewall
  * https://forge.puppet.com/puppetlabs/stdlib

### Beginning with sal

## Usage

To use load the SAL puppet module, declare this class in your manifest with `include sal`.

The firewall settings for SAL are somewhat complicated. It makes use of multicast/unicast networking that is a bit tricky to figure out. You'll likely need to refer to some of the following documentation on how to configure the `sal::firewall` parameters in a particular environment:
* https://community.rti.com/content/forum-topic/statically-configure-firewall-let-omg-dds-traffic-through
* https://github.com/lsst-ts/ts_sal/blob/develop/lsstsal/doc/SAL_User_Guide.pdf

## Reference

The following parameters let you extend SAL options beyond the default:

  * `sal::firewall::multicast_cidr` - String of CIDR address notation for multicast firewall rules
  * `sal::firewall::omgdds_ports` - Array of OMG DDS ports opened up in firewall rules
  * `sal::firewall::omgdds_subnets` - Hash of subnets that can send OMG DDS traffic
  * `sal::firewall::opensplice_ports` - String of OpenSplice ports opened up in firewall rules
  * `sal::firewall::opensplice_subnets` - Hash of subnets that can send OpenSplice traffic
  * `sal::install::environment_file` - String of local filename of SAL environment file
  * `sal::install::csc_packages` - Array of package names of CSC library packages
  * `sal::install::csc_version` - String of version number of CSC library packages
  * `sal::install::opensplice_packages` - Array of package names of OpenSpliceDDS package(s)
  * `sal::install::opensplice_version` - String of version number of OpenSpliceDDS package
  * `sal::install::yumrepo_baseurl` - String of yum repository baseurl containing OpenSpliceDDS package
  * `sal::prerequisites::pkg_list` - Array of packages to install as prerequisites

## Limitations

This SAL module only supports RHEL/CentOS servers that are configured to use `iptables`.

