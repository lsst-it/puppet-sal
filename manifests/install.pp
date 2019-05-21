# Install the LSST SAL software
#
# @summary Install the LSST SAL software
#
# @example
#   include sal::install
class sal::install (
    String   $environment_baseurl,
    String   $environment_file,
    String   $package,
    String   $version,
    String   $yumrepo_baseurl,
) {

  ## SETUP SAL YUM REPO
  yumrepo { 'lsst-ts-sal':
    ensure   => present,
    baseurl  => $yumrepo_baseurl,
    descr    => 'LSST TS-SAL',
    enabled  => 1,
    gpgcheck => 0,
  }
  
  ## INSTALL SAL/OPENSPLICE PACKAGE
  # OpenSpliceDDS-6.9.0
  package { $package:
    ensure => $version,
    require => [
      Yumrepo['lsst-ts-sal'],
    ],
  }

  ## GET THE SAL ENVIRONMENT SETUP
  file { $environment_file:
    source => $environment_baseurl,
  }

  ## ADD source /opt/sal-home/setup_SAL.env TO BASH LOGIN PROFILE  ??

}
