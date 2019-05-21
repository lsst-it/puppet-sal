# Puppet module for installing and configuring the LSST Service Abstraction Layer (SAL)
#
# @summary Install and configure the LSST Service Abstraction Layer (SAL)
#
# @example
#   include sal
class sal {
  include sal::prerequisites
  include sal::install
  include sal::firewall
}
